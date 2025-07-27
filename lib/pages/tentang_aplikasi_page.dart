import 'package:flutter/material.dart';

class TentangAplikasiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Aplikasi'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.info, color: Colors.blue),
              title: Text('Nama Aplikasi'),
              subtitle: Text('SIMA - Sistem Inventaris & Manajemen Aset'),
            ),
          ),
          SizedBox(height: 12),
          Card(
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.verified_user, color: Colors.green),
              title: Text('Pengembang'),
              subtitle: Text('Fairuz Wijaya'),
            ),
          ),
          SizedBox(height: 12),
          Card(
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.update, color: Colors.orange),
              title: Text('Versi'),
              subtitle: Text('1.0.0'),
            ),
          ),
          SizedBox(height: 12),
          Card(
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.email, color: Colors.red),
              title: Text('Kontak'),
              subtitle: Text('fairuz.dev@example.com'),
              onTap: () {
                // Tambahkan aksi jika ingin mengirim email
              },
            ),
          ),
        ],
      ),
    );
  }
}
