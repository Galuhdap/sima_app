import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/services/network_constans.dart';
import 'package:inventory_app/utils/ext/date_time_ext.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, String>> _filteredHistory = [];
  final List<Map<String, String>> _allHistory = [];

  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  Future<void> _fetchDataRiwayat() async {
    setState(() {
      _isLoading = true; // Mulai loading
    });
    try {
      var url = Uri.http(NetworkConstants.BASE_URL, '/api/riwayat');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _allHistory.clear();
          _allHistory.addAll(
            data.map(
              (item) => {
                "riwayat_id": item['riwayat_id'].toString(),
                "aktivitas": item['aktivitas'] ?? '',
                "user_id": item['user_id'].toString(),
                "user_name": item['user_name'] ?? '',
                'created_at': item['created_at'] ?? '',
              },
            ),
          );
          _filteredHistory = _allHistory;
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
    super.initState();
    _fetchDataRiwayat();
    _searchController.addListener(_filterHistory);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterHistory() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredHistory = _allHistory.where((entry) {
        return entry['aktivitas']!.toLowerCase().contains(query) ||
            entry['user_name']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat', style: TextStyle(color: Colors.white)),
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
                hintText: 'Cari Riwayat',
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
          : _filteredHistory.isEmpty
          ? Center(child: Text('Tidak ada data riwayat.'))
          : ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: _filteredHistory.length,
              separatorBuilder: (_, __) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = _filteredHistory[index];
                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: Icon(Icons.history, color: Colors.blue),
                    title: Text(item['aktivitas']!),
                    subtitle: Text(
                      DateTime.parse(
                        item['created_at']!,
                      ).toDateTimePartString(),
                    ),
                    // subtitle: Text(item['waktu']!.toFormattedDateTime()),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(item['user_name']!),
                          content: Text(
                            item['aktivitas'] ?? 'Tidak ada deskripsi.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Tutup'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
