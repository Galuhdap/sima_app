import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  void _sendResetRequest() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSending = true);

      Future.delayed(Duration(seconds: 2), () {
        setState(() => _isSending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permintaan reset dikirim ke email kamu!')),
        );
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lupa Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Icon(Icons.lock_outline, size: 100, color: Colors.blueAccent),
              SizedBox(height: 16),
              Text(
                'Reset Password',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
              ),
              SizedBox(height: 12),
              Text(
                'Masukkan email kamu dan kami akan kirimkan instruksi untuk mereset password.',
                style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!value.contains('@')) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.send),
                  onPressed: _isSending ? null : _sendResetRequest,
                  label: _isSending
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text('Kirim Permintaan'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                icon: Icon(Icons.arrow_back),
                label: Text('Kembali ke Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
