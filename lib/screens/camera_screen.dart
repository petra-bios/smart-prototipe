import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app_colors.dart';

/// Kamera in-app. Dipakai di Android dan web (getUserMedia).
///
/// Catatan web: browser hanya mengizinkan kamera pada
/// `http://localhost` atau HTTPS. Kalau di-serve lewat `file://`
/// atau IP http biasa, tombol kamera akan menampilkan pesan izin/konteks.
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  List<CameraDescription> _kamera = const [];
  CameraController? _kontroler;
  Uint8List? _hasilFoto;
  bool _memuat = true;
  String? _galat;
  int _indeksAktif = 0;

  @override
  void initState() {
    super.initState();
    _siapkan();
  }

  Future<void> _siapkan() async {
    try {
      final daftar = await availableCameras();
      if (!mounted) return;
      if (daftar.isEmpty) {
        setState(() {
          _memuat = false;
          _galat = 'Tidak ada kamera yang terdeteksi di perangkat ini.';
        });
        return;
      }
      _kamera = daftar;
      await _bukaKamera(0);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _memuat = false;
        _galat = kIsWeb
            ? 'Kamera butuh izin browser dan konteks aman (http://localhost atau HTTPS).\n\n$e'
            : 'Kamera gagal dibuka: $e';
      });
    }
  }

  Future<void> _bukaKamera(int indeks) async {
    await _kontroler?.dispose();
    final kontroler = CameraController(
      _kamera[indeks],
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await kontroler.initialize();
      if (!mounted) {
        await kontroler.dispose();
        return;
      }
      setState(() {
        _kontroler = kontroler;
        _indeksAktif = indeks;
        _memuat = false;
        _galat = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _memuat = false;
        _galat = kIsWeb
            ? 'Izin kamera ditolak atau tidak tersedia di browser.\n\n$e'
            : 'Kamera gagal diinisialisasi: $e';
      });
    }
  }

  Future<void> _ambilFoto() async {
    final kontroler = _kontroler;
    if (kontroler == null || !kontroler.value.isInitialized) return;
    if (kontroler.value.isTakingPicture) return;

    try {
      final berkas = await kontroler.takePicture();
      final bytes = await berkas.readAsBytes();
      if (!mounted) return;
      setState(() => _hasilFoto = bytes);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil foto: $e')),
      );
    }
  }

  Future<void> _gantiKamera() async {
    if (_kamera.length < 2) return;
    final berikutnya = (_indeksAktif + 1) % _kamera.length;
    setState(() => _memuat = true);
    await _bukaKamera(berikutnya);
  }

  @override
  void dispose() {
    _kontroler?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Kamera'),
        actions: [
          if (_kamera.length > 1)
            IconButton(
              onPressed: _gantiKamera,
              icon: const Icon(Icons.cameraswitch_outlined),
              tooltip: 'Ganti kamera',
            ),
        ],
      ),
      body: SafeArea(child: _isi()),
    );
  }

  Widget _isi() {
    if (_galat != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videocam_off_outlined, color: Colors.white54, size: 48),
              const SizedBox(height: 16),
              Text(
                _galat!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, height: 1.5),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _memuat = true;
                    _galat = null;
                  });
                  _siapkan();
                },
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_hasilFoto != null) {
      return Column(
        children: [
          Expanded(child: Center(child: Image.memory(_hasilFoto!, fit: BoxFit.contain))),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _hasilFoto = null),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white38),
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: const Text('Ulangi'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(_hasilFoto),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      minimumSize: const Size.fromHeight(52),
                    ),
                    child: const Text('Pakai Foto'),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final kontroler = _kontroler;
    if (_memuat || kontroler == null || !kontroler.value.isInitialized) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Center(child: CameraPreview(kontroler)),
        Positioned(
          bottom: 28,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: _ambilFoto,
              child: Container(
                width: 78,
                height: 78,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  color: Colors.white24,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 32),
              ),
            ),
          ),
        ),
        if (kIsWeb)
          const Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Text(
              'Web: kamera hanya aktif di localhost atau HTTPS',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
