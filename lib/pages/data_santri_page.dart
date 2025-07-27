import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:inventory_app/pages/data_santri_detail_page.dart';
import 'package:inventory_app/services/network_constans.dart';

class DataSantriPage extends StatefulWidget {
  @override
  _DataSantriPageState createState() => _DataSantriPageState();
}

class _DataSantriPageState extends State<DataSantriPage> {
  final List<Map<String, String>> _dataSantri = [];
  List<Map<String, String>> _filteredSantri = [];
  bool _isLoading = true;

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nisController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  Future<void> _fetchDataSantri() async {
    setState(() {
      _isLoading = true; // Mulai loading
    });
    try {
      var url = Uri.http(NetworkConstants.BASE_URL, '/api/santri');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _dataSantri.clear();
          _dataSantri.addAll(
            data.map(
              (item) => {
                'nama': item['nama'] ?? '',
                'alamat': item['alamat_santri'] ?? '',
                'kelas': item['kelas'] ?? '',
                'kamar': item['kamar'] ?? '',
                'wali_santri': item['wali_santri'] ?? '',
                'no_telp_wali_santri': item['no_telp_wali_santri'] ?? '',
                'tanggal_masuk': item['tanggal_masuk'] ?? '',
                'image': item['image'] ?? '',
              },
            ),
          );
          _filteredSantri = _dataSantri;
        });
      } else {
        _showSnackbar(
          'Gagal mengambil data santri. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      _showSnackbar('Terjadi kesalahan: ${e.toString()}');
      print('Error fetching data: $e'); // Tambahkan print untuk debugging error
    } finally {
      setState(() {
        _isLoading = false; // Selesai loading, apapun hasilnya
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDataSantri();
    _searchController.addListener(_searchSantri);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nisController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _searchSantri() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSantri = _dataSantri.where((santri) {
        final nama = santri['nama']!.toLowerCase();
        final nis = santri['nis']?.toLowerCase() ?? '';
        return nama.contains(query) || nis.contains(query);
      }).toList();
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffF8F8F8),
      appBar: AppBar(
        title: Text('Data Santri', style: TextStyle(color: Colors.white)),
        elevation: 4,
        shadowColor: Colors.black54,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,

              decoration: InputDecoration(
                hintText: 'Cari nama atau NIS...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body:
          _isLoading // <-- Cek _isLoading di sini
          ? Center(
              child: CircularProgressIndicator(),
            ) // Tampilkan loading indicator
          : _filteredSantri.isEmpty
          ? Center(child: Text('Data santri kosong atau tidak ditemukan'))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: ListView.builder(
                itemCount: _filteredSantri.length,
                itemBuilder: (context, index) {
                  final santri = _filteredSantri[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DataSantriDetailPage(
                              nama: santri['nama']!,
                              noTelp: santri['no_telp_wali_santri']!,
                              tanggal: santri['tanggal_masuk']!,
                              alamat: santri['alamat']!,
                              kamar: santri['kamar']!,
                              kelas: santri['kelas']!,
                              gambar: santri['image']!,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 24,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 80,
                              color: Colors.blue,
                              child: santri['image']! == ''
                                  ? Text(
                                      '?',
                                      style: TextStyle(color: Colors.black),
                                    )
                                  : Image.network(
                                      'http://${NetworkConstants.BASE_URL}/storage/santri/${santri['image']}',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            SizedBox(width: 10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      santri['nama']!,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      'No Kamar: ${santri['kamar']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      'Kelas: ${santri['kelas']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
