import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory_app/services/network_constans.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _showSnackbar(
    String message, {
    Color backgroundColor = Colors.redAccent,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        var url = Uri.http(NetworkConstants.BASE_URL, '/api/auth/login');
        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'email': _emailController.text.trim(),
            'password': _passwordController.text,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);
          final String accessToken = responseData['access_token'];
          final dynamic user = responseData['user'];

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('access_token', accessToken);

          if (user != null) {
            await prefs.setString('user_name', user['name'] ?? 'Pengguna');
            await prefs.setString('user_email', user['email'] ?? '');
          }

          _showSnackbar('Login berhasil!', backgroundColor: Colors.green);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainScreen()),
          );
        } else {
          final errorData = jsonDecode(response.body);
          String errorMessage = 'Username atau password salah!';
          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          } else if (errorData.containsKey('errors')) {
            errorMessage =
                errorData['errors'].values.first[0] ??
                'Terjadi kesalahan validasi.';
          }
          _showSnackbar(errorMessage);
        }
      } catch (e) {
        _showSnackbar('Terjadi kesalahan koneksi: ${e.toString()}');
        print('Error during login: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade900, Colors.purple.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white.withOpacity(0.95),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'SIMA',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900,
                          letterSpacing: 2,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Sistem Inventaris & Manajemen Aset',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.blue.shade900,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade900),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.purple.shade700,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? 'Wajib diisi'
                            : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible =
                                    !_isPasswordVisible; // Toggle state
                              });
                            },
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue.shade900,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade900),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.purple.shade700,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (val) =>
                            val == null || val.isEmpty ? 'Wajib diisi' : null,
                      ),
                      SizedBox(height: 16),
                      _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.purple.shade700,
                            )
                          : Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton.icon(
                                    onPressed: _login,
                                    icon: Icon(
                                      Icons.login,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Masuk',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      backgroundColor: Colors.purple.shade700,
                                      elevation: 6,
                                      shadowColor: Colors.purple.shade300,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/register');
                                  },
                                  child: Text(
                                    'Belum punya akun? Daftar',
                                    style: TextStyle(
                                      color: Colors.blue.shade900,
                                    ),
                                  ),
                                ),
                                // TextButton(
                                //   onPressed: () {
                                //     Navigator.pushNamed(
                                //       context,
                                //       '/forgot-password',
                                //     );
                                //   },
                                //   child: Text(
                                //     'Lupa Password?',
                                //     style: TextStyle(
                                //       color: Colors.purple.shade700,
                                //     ),
                                //   ),
                                // ),
                                SizedBox(height: 6),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
