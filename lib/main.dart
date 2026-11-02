import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const SmartPrototipeApp());
}

class SmartPrototipeApp extends StatelessWidget {
  const SmartPrototipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMART Prototipe',
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
