import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_colors.dart';
import '../services/push_service.dart';

/// Format ringkas untuk waktu terbit token (dd/MM HH:mm, waktu lokal).
String _formatWaktu(DateTime waktu) {
  final l = waktu.toLocal();
  String dua(int n) => n.toString().padLeft(2, '0');
  return '${dua(l.day)}/${dua(l.month)} ${dua(l.hour)}:${dua(l.minute)}';
}

/// Layar status push notifikasi (FCM).
///
/// Menampilkan apakah konfigurasi FCM sudah lengkap, token perangkat, dan
/// nilai build-flag mana yang masih kosong — supaya tidak perlu nebak-nebak
/// saat menguji push di Android maupun web.
class PushStatusScreen extends StatefulWidget {
  const PushStatusScreen({super.key, this.autoInisialisasi = true});

  /// Dimatikan di tes widget supaya tidak menunggu kanal platform Firebase.
  final bool autoInisialisasi;

  @override
  State<PushStatusScreen> createState() => _PushStatusScreenState();
}

class _PushStatusScreenState extends State<PushStatusScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.autoInisialisasi) PushService.instance.inisialisasi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: ValueListenableBuilder<StatusPush>(
        valueListenable: PushService.instance.status,
        builder: (context, status, _) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _kartuStatus(status),
              const SizedBox(height: 20),
              const Text(
                'Android: cukup taruh android/app/google-services.json, '
                'plugin Gradle dipasang otomatis saat build.',
                style: TextStyle(color: AppColors.textSecondary, height: 1.4),
              ),
              const SizedBox(height: 8),
              if (KonfigurasiPush.hilang.isNotEmpty) ...[
                const Text(
                  'Nilai yang belum diisi',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  KonfigurasiPush.hilang.join(', '),
                  style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Cara mengisi: buka Firebase Console → Project settings → '
                  'General → Your apps, lalu build dengan --dart-define '
                  '(lihat README-PUSH.md).',
                  style: TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
                const SizedBox(height: 20),
              ],
              if (PushService.instance.token != null) ...[
                Row(
                  children: [
                    const Expanded(
                      child: Text('Token perangkat',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    TextButton.icon(
                      onPressed: () async {
                        await Clipboard.setData(
                          ClipboardData(text: PushService.instance.token!),
                        );
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Token disalin')),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 16),
                      label: const Text('Salin'),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                SelectableText(
                  PushService.instance.token!,
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                ),
                if (PushService.instance.waktuToken != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Terbit: ${_formatWaktu(PushService.instance.waktuToken!)}',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
              ],
              if (PushService.instance.galat != null) ...[
                const Text('Galat', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(
                  PushService.instance.galat!,
                  style: const TextStyle(color: Colors.orange, fontSize: 12),
                ),
                const SizedBox(height: 16),
              ],
              ValueListenableBuilder<RemoteMessage?>(
                valueListenable: PushService.instance.pesanTerakhir,
                builder: (context, pesan, _) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pesan terakhir yang diterima',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          pesan?.notification?.title ?? 'Belum ada pesan masuk',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        if (pesan?.notification?.body != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            pesan!.notification!.body!,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => PushService.instance.perbaruiToken(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  minimumSize: const Size.fromHeight(48),
                ),
                child: const Text('Minta izin / perbarui token'),
              ),
              const SizedBox(height: 12),
              Text(
                'Build: ${KonfigurasiPush.buildTag} · '
                'config ${6 - KonfigurasiPush.hilang.length}/6',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _kartuStatus(StatusPush status) {
    final (warna, judul, isi) = switch (status) {
      StatusPush.belumDikonfigurasi => (
          Colors.grey,
          'Belum dikonfigurasi',
          'Build ini dibuat tanpa nilai FCM. Aplikasi tetap jalan, '
              'tapi belum bisa menerima push.',
        ),
      StatusPush.menyiapkan => (Colors.orange, 'Menyiapkan…', 'Meminta izin dan mengambil token.'),
      StatusPush.siap => (
          Colors.green,
          'Siap menerima push',
          kIsWeb
              ? 'Token sudah diambil. Kirim pesan ke token ini dari Firebase '
                  'Console (web tidak memakai topik).'
              : 'Token sudah diambil dan perangkat berlangganan topik "semua".',
        ),
      StatusPush.gagal => (
          Colors.red,
          'Gagal',
          'Inisialisasi FCM gagal — lihat galat di bawah.',
        ),
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: warna.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: warna.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.notifications_active_outlined, color: warna),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  judul,
                  style: TextStyle(fontWeight: FontWeight.bold, color: warna),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(isi, style: const TextStyle(color: AppColors.textSecondary, height: 1.5)),
        ],
      ),
    );
  }
}
