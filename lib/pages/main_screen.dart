import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory_app/pages/home_page.dart'; // ignore: unused_import
import 'package:inventory_app/pages/login_page.dart';
import 'package:inventory_app/pages/profile_page.dart'; // ignore: unused_import
import 'package:inventory_app/services/network_constans.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ignore: unused_import
import 'package:http/http.dart' as http;

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("")),
      drawer: AnimatedDrawer(),
      body: HomePage(),
    );
  }
}

class AnimatedDrawer extends StatefulWidget {
  final Function()? onClose;

  const AnimatedDrawer({Key? key, this.onClose}) : super(key: key);

  @override
  _AnimatedDrawerState createState() => _AnimatedDrawerState();
}

class _AnimatedDrawerState extends State<AnimatedDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _iconController;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    _loadUserData();
    super.initState();
    _iconController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
      _isDrawerOpen ? _iconController.forward() : _iconController.reverse();
    });
  }

  String _userName = 'Pengguna';
  String _userEmail = '';
  bool _isLoadingLogout = false;

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Pengguna';
      _userEmail = prefs.getString('user_email') ?? ''; // Muat email juga
    });
  }

  void _showSnackbar(
    String message, {
    Color backgroundColor = Colors.redAccent,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  Future<void> _logout() async {
    setState(() {
      _isLoadingLogout = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      await prefs.remove('access_token');
      await prefs.remove('user_name');
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
        );
      }
      return;
    }

    try {
      var url = Uri.http(NetworkConstants.BASE_URL, '/api/auth/logout');
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        // Logout dari server berhasil
        _showSnackbar(
          'Anda telah berhasil logout!',
          backgroundColor: Colors.green,
        );
      } else {
        final errorData = jsonDecode(response.body);
        String errorMessage =
            errorData['message'] ?? 'Gagal logout dari server.';
        _showSnackbar('Logout server error: $errorMessage');
      }
    } catch (e) {
      _showSnackbar('Terjadi kesalahan koneksi saat logout: ${e.toString()}');
      print('Error during logout API call: $e');
    } finally {
      await prefs.remove('access_token');
      await prefs.remove('user_name');
      await prefs.remove('user_email');

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
        );
      }
      setState(() {
        _isLoadingLogout = false;
      });
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _isLoadingLogout
          ? AlertDialog(
              content: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          : AlertDialog(
              title: Text("Logout"),
              content: Text("Apakah kamu yakin ingin logout?"),
              actions: [
                TextButton(
                  child: Text("Batal"),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
                TextButton(child: Text("Logout"), onPressed: () => _logout()),
              ],
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("${_userName}"),
            accountEmail: Text("${_userEmail}"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: colorScheme.onPrimary,
              child: Icon(Icons.person, size: 40, color: colorScheme.primary),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.person,
            text: "Profil",
            onTap: () {
              Navigator.popAndPushNamed(context, '/profil');
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: "Pengaturan",
            onTap: () {
              Navigator.popAndPushNamed(context, '/settings');
            },
          ),
          _buildDrawerItem(
            icon: Icons.lock,
            text: "Ganti Password",
            onTap: () {
              Navigator.popAndPushNamed(context, '/ganti_password');
            },
          ),
          Divider(),
          _buildDrawerItem(
            icon: Icons.help,
            text: "Bantuan / FAQ",
            onTap: () {
              Navigator.popAndPushNamed(context, '/faq');
            },
          ),
          _buildDrawerItem(
            icon: Icons.info,
            text: "Tentang Aplikasi",
            onTap: () {
              Navigator.popAndPushNamed(context, '/tentang_aplikasi');
            },
          ),
          Divider(),
          _buildDrawerItem(
            icon: Icons.logout,
            text: "Logout",
            onTap: () => _showLogoutDialog(context),
            iconColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    bool tapped = false;
    return StatefulBuilder(
      builder: (context, setInnerState) {
        final colorScheme = Theme.of(context).colorScheme;
        return GestureDetector(
          onTapDown: (_) => setInnerState(() => tapped = true),
          onTapUp: (_) => setInnerState(() => tapped = false),
          onTapCancel: () => setInnerState(() => tapped = false),
          child: AnimatedScale(
            scale: tapped ? 1.1 : 1.0,
            duration: Duration(milliseconds: 200),
            child: ListTile(
              leading: Icon(icon, color: iconColor ?? colorScheme.onSurface),
              title: Text(text),
              onTap: onTap,
            ),
          ),
        );
      },
    );
  }
}
