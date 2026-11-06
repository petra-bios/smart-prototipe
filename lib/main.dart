import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'screens/login_screen.dart';
import 'services/push_service.dart';

final GlobalKey<ScaffoldMessengerState> kunciMessenger = GlobalKey<ScaffoldMessengerState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  // FCM: dimulai sekali saat aplikasi jalan. Tanpa konfigurasi, statusnya
  // "belum dikonfigurasi" dan aplikasi tetap berjalan normal.
  PushService.instance.inisialisasi();
  // Saat tab terlihat, FCM tidak menampilkan notifikasi sistem — pesan hanya
  // masuk ke onMessage. Tampilkan di dalam aplikasi supaya tetap kelihatan.
  PushService.instance.pesanTerakhir.addListener(() {
    final pesan = PushService.instance.pesanTerakhir.value?.notification;
    if (pesan == null) return;
    kunciMessenger.currentState?.showSnackBar(
      SnackBar(content: Text([pesan.title, pesan.body].whereType<String>().join(' — '))),
    );
  });
  runApp(const SmartPrototipeApp());
}

class SmartPrototipeApp extends StatelessWidget {
  const SmartPrototipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMART Prototipe',
      scaffoldMessengerKey: kunciMessenger,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryRed,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryRed,
          primary: AppColors.primaryRed,
        ),
        scaffoldBackgroundColor: AppColors.backgroundLight,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
