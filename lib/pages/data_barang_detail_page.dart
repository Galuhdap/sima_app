import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory_app/services/network_constans.dart';
import 'package:http/http.dart' as http;

class DataBarangDetailPage extends StatefulWidget {
  final String barang;
  const DataBarangDetailPage({super.key, required this.barang});

  @override
  State<DataBarangDetailPage> createState() => _DataBarangDetailPageState();
}

class _DataBarangDetailPageState extends State<DataBarangDetailPage> {
  List<Map<String, String>> _barangList = [];
  final List<Map<String, String>> _allBarang = [];
  bool _isLoading = true;

  Future<void> _fetchDataBarang() async {
    setState(() {
      _isLoading = true; // Mulai loading
    });
    try {
      var url = Uri.http(
        NetworkConstants.BASE_URL,
        '/api/barang-by-lokasi/${widget.barang}',
      );
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _allBarang.clear();
          _allBarang.addAll(
            data.map(
              (item) => {
                "inventaris_id": item['inventaris_id'].toString(),
                "nama_barang": item['nama_barang'],
                "kategori": item['kategori'],
                "jumlah": item['jumlah'].toString(),
                "lokasi": item['lokasi'],
                "tanggal_input": item['tanggal_input'],
                "user_id": item['user_id'].toString(),
                "waktu": item['created_at'],
                "status": item['status'],
              },
            ),
          );
          _barangList = _allBarang;
        });
      } else {
        _showSnackbar(
          'Gagal mengambil data barang. Status: ${response.statusCode}',
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
    _fetchDataBarang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Data Inventaris',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 4,
        shadowColor: Colors.black54,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body:
          _isLoading // <-- Cek _isLoading di sini
          ? Center(
              child: CircularProgressIndicator(),
            ) // Tampilkan loading indicator
          : _barangList.isEmpty
          ? Center(child: Text('Belum ada data barang di lokasi ini.'))
          : Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ListView.builder(
                itemCount: _barangList.length,
                itemBuilder: (context, index) {
                  final barang = _barangList[index];
                  final nama = barang["nama_barang"] ?? 'Nama tidak tersedia';
                  final deskripsi =
                      barang["kategori"] ?? 'Deskripsi tidak tersedia';
                  final tempat = barang["lokasi"] ?? 'Tempat tidak tersedia';
                  final status = barang["status"] ?? 'status tidak tersedia';
                  final jumlah = barang["jumlah"] ?? 'jumlah tidak tersedia';
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
                          Icons.inventory,
                          color: Colors.blueAccent,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        nama,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.description,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    deskripsi,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    tempat,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            status,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            jumlah,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
          ),
    );
  }
}
