import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/services/network_constans.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic> _profileData = {};
  bool _isLoading = true;

  Future<void> _fetchDataProfile() async {
    setState(() {
      _isLoading = true; // Mulai loading
    });
    try {
      var url = Uri.http(NetworkConstants.BASE_URL, '/api/profile');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        final dynamic decodedData = jsonDecode(response.body);

        final Map<String, dynamic> data =
            decodedData is List && decodedData.isNotEmpty ? decodedData[0] : {};

        setState(() {
          _profileData = {
            "nama_pondok": data['nama_pondok']?.toString() ?? 'N/A',
            "pimpinan": data['pimpinan']?.toString() ?? 'N/A',
            "tahun_berdiri": data['tahun_berdiri']?.toString() ?? 'N/A',
            "visi_misi": data['visi_misi']?.toString() ?? 'N/A',
            "alamat": data['alamat']?.toString() ?? 'N/A',
            "telepon": data['telepon']?.toString() ?? 'N/A',
            "email": data['email']?.toString() ?? 'N/A',
            "deskripsi": data['deskripsi']?.toString() ?? 'N/A',
            "logo": data['logo']?.toString() ?? '',
            "created_at": data['created_at']?.toString() ?? '',
          };
        });
      } else {
        _showSnackbar(
          'Gagal mengambil data profil. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      _showSnackbar('Terjadi kesalahan: ${e.toString()}');
      print('Error fetching profile data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchDataProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _profileData
                .isEmpty // Cek jika data profil kosong
          ? Center(child: Text('Data profil tidak ditemukan.'))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 54,
                      backgroundColor: Colors.blue.shade100,

                      backgroundImage: NetworkImage(
                        'http://${NetworkConstants.BASE_URL}/storage/${_profileData['logo']}',
                      ),
                      child: _profileData['logo'] == ''
                          ? Icon(
                              Icons.account_circle,
                              size: 108,
                              color: Colors.blue,
                            )
                          : null,
                    ),
                    SizedBox(height: 16),
                    Text(
                      // Tampilkan nama_pondok dari data profil
                      _profileData['nama_pondok'] ?? 'Nama Pondok',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      // Tampilkan pimpinan atau deskripsi singkat
                      _profileData['pimpinan'] ?? 'Pimpinan',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.blueGrey.shade700,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    Text(
                      // Tampilkan email dari data profil
                      _profileData['email'] ?? 'email@example.com',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 24),
                    // Contoh menampilkan detail lain dari profil
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alamat:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(_profileData['alamat']),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Telepon:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(_profileData['telepon']),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Visi Dan Misi:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(_profileData['visi_misi']),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tahun Berdiri:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(_profileData['tahun_berdiri']),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 24,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deskripsi:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(_profileData['deskripsi']),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
            ),
    );
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
