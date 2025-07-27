import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/theme_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadDarkModePref();
  }

  Future<void> _loadDarkModePref() async {
    final prefs = await SharedPreferences.getInstance();
    final darkModePref = prefs.getBool('darkMode');
    if (darkModePref != null) {
      setState(() {
        _darkMode = darkModePref;
      });
      ThemeController.toggleTheme(darkModePref);
    }
  }

  void _toggleNotifications(bool value) {
    setState(() {
      _notificationsEnabled = value;
    });
  }

  Future<void> _toggleDarkMode(bool value) async {
    setState(() {
      _darkMode = value;
    });
    ThemeController.toggleTheme(value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Notifikasi'),
            subtitle: const Text('Aktifkan atau nonaktifkan notifikasi'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: _toggleNotifications,
            ),
          ),
          ListTile(
            title: const Text('Mode Gelap'),
            subtitle: const Text('Aktifkan tampilan mode gelap'),
            trailing: Switch(
              value: _darkMode,
              onChanged: _toggleDarkMode,
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Ganti Password'),
            leading: const Icon(Icons.lock),
            onTap: () {
              Navigator.pushNamed(context, '/ganti_password');
            },
          ),
          ListTile(
            title: const Text('Tentang Aplikasi'),
            leading: const Icon(Icons.info_outline),
            onTap: () {
              Navigator.pushNamed(context, '/tentang_aplikasi');
            },
          ),
        ],
      ),
    );
  }
}
