import 'package:flutter/material.dart';
import 'package:inventory_app/pages/splash_page.dart';
import 'pages/login_page.dart';
import 'package:inventory_app/pages/settings_page.dart';
import 'controllers/theme_controller.dart';
import 'package:inventory_app/pages/faq_page.dart';
import 'package:inventory_app/pages/tentang_aplikasi_page.dart';
import 'package:inventory_app/pages/ganti_password_page.dart';
import 'pages/history_page.dart';
import 'package:inventory_app/pages/data_barang_page.dart';
import 'package:inventory_app/pages/data_santri_page.dart';
import 'package:inventory_app/pages/profile_page.dart';
import 'package:inventory_app/pages/laporan_page.dart';
import 'pages/forgot_password_page.dart';
import 'pages/register_page.dart';
import 'package:inventory_app/pages/admin_page.dart';
import 'package:inventory_app/pages/user_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.themeMode,
      builder: (context, currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashPage(),
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: currentMode,
          routes: {
            '/login': (context) => LoginPage(),
            '/history': (context) => HistoryPage(),
            '/data_santri': (context) => DataSantriPage(),
            '/profil': (context) => ProfilePage(),
            '/settings': (context) => SettingsPage(),
            '/faq': (context) => FAQPage(),
            '/tentang_aplikasi': (context) => TentangAplikasiPage(),
            '/ganti_password': (context) => GantiPasswordPage(),
            '/laporan': (context) => LaporanPage(),
            '/forgot-password': (context) => ForgotPasswordPage(),
            '/register': (context) => RegisterPage(),
            '/data_barang': (context) => DataBarangPage(),
            '/admin': (context) => AdminPage(),
            '/user': (context) => UserPage(),
          },
        );
      },
    );
  }
}
