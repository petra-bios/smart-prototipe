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

  Future<void> inisialisasi() async {
    if (status.value == StatusPush.siap) return;

    if (!KonfigurasiPush.lengkap) {
      status.value = StatusPush.belumDikonfigurasi;
      return;
    }

    status.value = StatusPush.menyiapkan;
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: KonfigurasiPush.opsi());
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

      await messaging.subscribeToTopic('semua');

      _langgananPesan?.cancel();
      _langgananPesan = FirebaseMessaging.onMessage.listen((pesan) {
        pesanTerakhir.value = pesan;
      });

      status.value = StatusPush.siap;
    } catch (e) {
      galat = e.toString();
      status.value = StatusPush.gagal;
    }
  }

  /// firebase_messaging 17: pendaftaran lewat register() lalu token
  /// diterima dari stream onRegistered.
  Future<String?> _daftarkan(FirebaseMessaging messaging) async {
    final token = Completer<String?>();
    final langganan = messaging.onRegistered.listen((nilai) {
      if (!token.isCompleted) token.complete(nilai);
    });

    try {
      await messaging.register();
      return await token.future.timeout(
        const Duration(seconds: 15),
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
