import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory_app/services/network_constans.dart';
import 'package:http/http.dart' as http;

class LaporanPage extends StatefulWidget {
  const LaporanPage({Key? key}) : super(key: key);

  @override
  State<LaporanPage> createState() => _LaporanPageState();
}

class _LaporanPageState extends State<LaporanPage> {
  List<Map<String, String>> _laporanList = [];
  final List<Map<String, String>> _allLaporan = [];
  bool _isLoading = true;
  int _totalSeluruhBarang = 0;

  Future<void> _fetchDataLaporan() async {
    setState(() {
      _isLoading = true; // Mulai loading
    });
    try {
      var url = Uri.http(NetworkConstants.BASE_URL, '/api/laporan');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> data = responseData['laporans'] ?? [];

        // Ambil nilai 'total_seluruh_barang'
        final int fetchedTotalBarang =
            responseData['total_seluruh_barang'] ?? 0;
        setState(() {
          _allLaporan.clear();
          _allLaporan.addAll(
            data.map(
              (item) => {
                "laporan_id": item['laporan_id']?.toString() ?? '',
                "nama_barang": item['nama_barang']?.toString() ?? '',
                "total_barang":
                    item['total_barang']?.toString() ??
                    '', // Simpan sebagai String jika perlu
                "judul": item['judul']?.toString() ?? '',
                "deskripsi": item['deskripsi']?.toString() ?? '',
                "user_id": item['user_id']?.toString() ?? '',
                "created_at": item['created_at']?.toString() ?? '',
                "updated_at": item['updated_at']?.toString() ?? '',
                "status": item['status']?.toString() ?? '',
              },
            ),
          );
          _laporanList = _allLaporan;
          _totalSeluruhBarang = fetchedTotalBarang;
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

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchDataLaporan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan', style: TextStyle(color: Colors.white)),
        elevation: 4,
        shadowColor: Colors.black54,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: ListTile(
                title: Text('Total Barang'),
                trailing: Text(
                  _totalSeluruhBarang.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child:
                  _isLoading // <-- Cek _isLoading di sini
                  ? Center(
                      child: CircularProgressIndicator(),
                    ) // Tampilkan loading indicator
                  : _laporanList.isEmpty
                  ? Center(
                      child: Text('Data laporan kosong atau tidak ditemukan'),
                    )
                  : ListView.builder(
                      itemCount: _laporanList.length,
                      itemBuilder: (context, index) {
                        final laporan = _laporanList[index];
                        return ListTile(
                          title: Text(laporan['nama_barang']!),
                          trailing: Text(laporan["total_barang"]!),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
