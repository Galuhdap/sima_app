import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory_app/pages/data_barang_detail_page.dart';
import 'package:inventory_app/services/network_constans.dart';
import 'package:http/http.dart' as http;

class DataBarangPage extends StatefulWidget {
  const DataBarangPage({Key? key}) : super(key: key);

  @override
  _DataBarangPageState createState() => _DataBarangPageState();
}

class _DataBarangPageState extends State<DataBarangPage> {
  bool _isLoading = true;
  List<Map<String, String>> _allLokasi = [];
  List<Map<String, String>> _lokasiList = [];

  Future<void> _fetchDataLokasi() async {
    setState(() {
      _isLoading = true;
    });
    try {
      var url = Uri.http(NetworkConstants.BASE_URL, '/api/lokasi');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          final List<dynamic> data = jsonDecode(response.body);

          setState(() {
            _allLokasi.clear();
            _allLokasi.addAll(
              data.map((item) => {"nama_lokasi": item['nama_lokasi'] ?? ''}),
            );
            _lokasiList = _allLokasi;
            print(_lokasiList);
          });
        });
      } else {
        _showSnackbar(
          'Gagal mengambil data lokasi. Status: ${response.statusCode}',
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

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    // TODO: implement initState
    // _fetchDataBarang();
    _fetchDataLokasi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Inventaris', style: TextStyle(color: Colors.white)),
        elevation: 4,
        shadowColor: Colors.black54,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child:
            _isLoading // <-- Cek _isLoading di sini
            ? Center(
                child: CircularProgressIndicator(),
              ) // Tampilkan loading indicator
            : _lokasiList.isEmpty
            ? Center(
                child: Text(
                  'Belum ada data barang di lokasi ini.',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _lokasiList.length,
                itemBuilder: (context, index) {
                  final lokasi = _lokasiList[index];
                  final nama_lokasi = lokasi["nama_lokasi"]!;
                  return Card(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.black26,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: theme.colorScheme.primary.withOpacity(
                          0.1,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.blueAccent,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        nama_lokasi,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                DataBarangDetailPage(barang: nama_lokasi),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
