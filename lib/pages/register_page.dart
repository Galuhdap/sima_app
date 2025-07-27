import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/pages/login_page.dart';
import 'dart:convert';

import 'package:inventory_app/services/network_constans.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isRegistering = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void _showSnackbar(
    String message, {
    Color backgroundColor = Colors.redAccent,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isRegistering = true);

      // Menggunakan NetworkConstants.BASE_URL
      final url = Uri.http(NetworkConstants.BASE_URL, '/api/auth/register');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': _nameController.text.trim(), // Trim spasi
            'email': _emailController.text.trim(), // Trim spasi
            'password': _passwordController.text,
            'password_confirmation':
                _confirmPasswordController.text, // <-- PENTING: Kirim ini
          }),
        );

        setState(() => _isRegistering = false);

        if (response.statusCode == 201) {
          // Pendaftaran berhasil, Anda bisa langsung login atau arahkan ke halaman login
          _showSnackbar(
            'Pendaftaran berhasil! Silakan login.',
            backgroundColor: Colors.green,
          );
          // Menggunakan Navigator.pop jika RegisterPage di-push dari LoginPage
          // atau Navigator.pushReplacement jika ingin ganti halaman sepenuhnya
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          // Tangani error dari API Laravel
          final errorData = jsonDecode(response.body);
          String errorMessage = 'Pendaftaran gagal.';

          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          }
          if (errorData.containsKey('errors')) {
            // Ini akan mengiterasi error validasi dari Laravel
            // dan mengambil pesan error pertama dari setiap field
            errorMessage += '\n';
            errorData['errors'].forEach((field, messages) {
              errorMessage += '${messages.join(', ')}\n';
            });
          }
          _showSnackbar(errorMessage);
        }
      } catch (e) {
        setState(() => _isRegistering = false);
        _showSnackbar('Terjadi kesalahan koneksi: ${e.toString()}');
        print('Error during registration: $e'); // Untuk debugging lebih lanjut
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Akun', style: TextStyle(color: Colors.white)),
        elevation: 4,
        shadowColor: Colors.black54,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(Icons.person_add_alt, size: 100, color: Colors.blueAccent),
              SizedBox(height: 16),
              Text(
                'Buat Akun Baru',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 32),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Nama wajib diisi' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Email wajib diisi';
                  if (!value.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                // Mengatur visibilitas password berdasarkan state
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  // Icon mata di sini
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
                ),
                validator: (value) => value != null && value.length >= 8
                    ? null
                    : 'Password minimal 8 karakter',
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                // Mengatur visibilitas konfirmasi password
                obscureText: !_isConfirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: OutlineInputBorder(),
                  // Icon mata di sini
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible =
                            !_isConfirmPasswordVisible; // Toggle state
                      });
                    },
                  ),
                ),
                validator: (value) => value == _passwordController.text
                    ? null
                    : 'Password tidak cocok',
              ),
              SizedBox(height: 24),
              _isRegistering
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isRegistering ? null : _register,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.blue,
                          ),
                          foregroundColor: MaterialStateProperty.all(
                            Colors.white,
                          ),
                        ),
                        child: Text('Daftar'),
                      ),
                    ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
