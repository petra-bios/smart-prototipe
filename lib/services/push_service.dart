import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Nilai konfigurasi FCM dikirim saat build, bukan ditanam di kode:
///
/// flutter build web --release \
///   --dart-define=FCM_API_KEY=... --dart-define=FCM_PROJECT_ID=... \
///   --dart-define=FCM_SENDER_ID=... --dart-define=FCM_WEB_APP_ID=... \
///   --dart-define=FCM_VAPID_KEY=...
///
/// Android memakai FCM_ANDROID_APP_ID. Kalau salah satu kosong, push tidak
/// diinisialisasi dan aplikasi menampilkan status "belum dikonfigurasi"
/// (bukan crash).
class KonfigurasiPush {
  KonfigurasiPush._();

  static const String apiKey = String.fromEnvironment('FCM_API_KEY');
  static const String projectId = String.fromEnvironment('FCM_PROJECT_ID');
  static const String senderId = String.fromEnvironment('FCM_SENDER_ID');
  static const String androidAppId = String.fromEnvironment('FCM_ANDROID_APP_ID');
  static const String webAppId = String.fromEnvironment('FCM_WEB_APP_ID');
  static const String vapidKey = String.fromEnvironment('FCM_VAPID_KEY');
  static const String storageBucket =
      String.fromEnvironment('FCM_STORAGE_BUCKET', defaultValue: '');

  /// Penanda build — supaya bisa dipastikan bundle mana yang sedang dibuka
  /// (masalah paling sering: browser menyajikan bundle lama dari cache).
  static const String buildTag =
      String.fromEnvironment('BUILD_TAG', defaultValue: 'dev');

  static bool get lengkap {
    final appId = kIsWeb ? webAppId : androidAppId;
    final dasar = apiKey.isNotEmpty &&
        projectId.isNotEmpty &&
        senderId.isNotEmpty &&
        appId.isNotEmpty;
    if (!dasar) return false;
    if (kIsWeb && vapidKey.isEmpty) return false;
    return true;
  }

  static FirebaseOptions opsi() => FirebaseOptions(
        apiKey: apiKey,
        projectId: projectId,
        messagingSenderId: senderId,
        appId: kIsWeb ? webAppId : androidAppId,
        storageBucket: storageBucket.isEmpty ? null : storageBucket,
      );

  /// Daftar nilai yang masih kosong — ditampilkan di layar status.
  static List<String> get hilang {
    final hasil = <String>[];
    if (apiKey.isEmpty) hasil.add('FCM_API_KEY');
    if (projectId.isEmpty) hasil.add('FCM_PROJECT_ID');
    if (senderId.isEmpty) hasil.add('FCM_SENDER_ID');
    if (kIsWeb && webAppId.isEmpty) hasil.add('FCM_WEB_APP_ID');
    if (!kIsWeb && androidAppId.isEmpty) hasil.add('FCM_ANDROID_APP_ID');
    if (kIsWeb && vapidKey.isEmpty) hasil.add('FCM_VAPID_KEY');
    return hasil;
  }
}

enum StatusPush { belumDikonfigurasi, menyiapkan, siap, gagal }

class PushService {
  PushService._();

  static final PushService instance = PushService._();

  final ValueNotifier<StatusPush> status =
      ValueNotifier<StatusPush>(StatusPush.belumDikonfigurasi);
  final ValueNotifier<RemoteMessage?> pesanTerakhir =
      ValueNotifier<RemoteMessage?>(null);

  String? token;
  String? galat;
  bool izinDiberikan = false;
  StreamSubscription<RemoteMessage>? _langgananPesan;

  /// Kembalikan ke kondisi awal — dipakai tes supaya status tidak bocor
  /// antar kasus (singleton).
  @visibleForTesting
  void setelUlang() {
    status.value = StatusPush.belumDikonfigurasi;
    galat = null;
    token = null;
    izinDiberikan = false;
  }

  Future<void> inisialisasi() async {
    if (status.value == StatusPush.siap) return;

    status.value = StatusPush.menyiapkan;
    try {
      if (Firebase.apps.isEmpty) {
        if (KonfigurasiPush.lengkap) {
          await Firebase.initializeApp(options: KonfigurasiPush.opsi());
        } else if (!kIsWeb) {
          // Android: opsi dibaca langsung dari android/app/google-services.json
          // (plugin Gradle dipasang otomatis kalau berkas itu ada).
          await Firebase.initializeApp().timeout(const Duration(seconds: 20));
        } else {
          galat = 'Konfigurasi web belum diisi: '
              '${KonfigurasiPush.hilang.join(', ')}';
          status.value = StatusPush.belumDikonfigurasi;
          return;
        }
      }

      final messaging = FirebaseMessaging.instance;
      final pengaturan = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      izinDiberikan = pengaturan.authorizationStatus ==
              AuthorizationStatus.authorized ||
          pengaturan.authorizationStatus == AuthorizationStatus.provisional;

      token = await _daftarkan(messaging);

      // Token kosong = belum bisa menerima push sama sekali. Dulu statusnya
      // tetap "siap" sehingga aplikasi terlihat sehat padahal tidak ada
      // token yang bisa dikirimi pesan.
      if (token == null || token!.isEmpty) {
        galat = kIsWeb
            ? 'Token belum terbit. Pastikan izin notifikasi diberikan, halaman '
                'dibuka lewat localhost atau HTTPS, lalu tekan '
                '"Minta izin / perbarui token".'
            : 'Token belum terbit — periksa koneksi internet dan konfigurasi FCM.';
        status.value = StatusPush.gagal;
        return;
      }

      // Langganan topik hanya ada di Android/iOS; di web FCM tidak
      // mendukungnya (lempar UnimplementedError) — di sana pengiriman
      // langsung ke token, jadi dilewati dan status tetap "siap".
      if (!kIsWeb) {
        await messaging.subscribeToTopic('semua');
      }

      _langgananPesan?.cancel();
      _langgananPesan = FirebaseMessaging.onMessage.listen((pesan) {
        pesanTerakhir.value = pesan;
      });

      status.value = StatusPush.siap;
    } catch (e) {
      galat = e.toString();
      status.value =
          KonfigurasiPush.lengkap ? StatusPush.gagal : StatusPush.belumDikonfigurasi;
    }
  }

  /// firebase_messaging 17: pendaftaran lewat register() lalu token
  /// diterima dari stream onRegistered.
  ///
  /// Di web, register() WAJIB diberi `vapidKey` dan jalur service worker —
  /// tanpa keduanya token tidak pernah terbit (gejalanya: status siap tapi
  /// Token perangkat kosong).
  Future<String?> _daftarkan(FirebaseMessaging messaging) async {
    final token = Completer<String?>();
    final langganan = messaging.onRegistered.listen((nilai) {
      if (!token.isCompleted) token.complete(nilai);
    });

    try {
      await messaging
          .register(
            vapidKey: kIsWeb && KonfigurasiPush.vapidKey.isNotEmpty
                ? KonfigurasiPush.vapidKey
                : null,
            serviceWorkerScriptPath:
                kIsWeb ? '/firebase-messaging-sw.js' : null,
          )
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () {},
          );
      return await token.future.timeout(
        const Duration(seconds: 20),
        onTimeout: () => null,
      );
    } finally {
      await langganan.cancel();
    }
  }

  Future<void> perbaruiToken() async {
    if (status.value != StatusPush.siap) {
      await inisialisasi();
      return;
    }
    try {
      token = await _daftarkan(FirebaseMessaging.instance);
    } catch (e) {
      galat = e.toString();
    }
  }
}
