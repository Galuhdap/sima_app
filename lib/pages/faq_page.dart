import 'package:flutter/material.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  final List<Map<String, String>> _faqList = [
    {
      'question': 'Bagaimana cara menambahkan data barang?',
      'answer': 'Klik tombol tambah (+) pada halaman Data Barang dan isi formulir yang tersedia.'
    },
    {
      'question': 'Bagaimana cara mengedit data santri?',
      'answer': 'Di halaman Data Santri, klik ikon pensil pada item santri yang ingin diedit.'
    },
    {
      'question': 'Apa yang harus dilakukan jika lupa password?',
      'answer': 'Hubungi admin sistem untuk mereset password Anda.'
    },
    {
      'question': 'Bagaimana melihat laporan inventaris?',
      'answer': 'Buka halaman Laporan dari menu utama untuk melihat data ringkasan barang.'
    },
  ];

  List<Map<String, String>> _filteredFAQ = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredFAQ = _faqList;
    _searchController.addListener(_filterFAQ);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterFAQ() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFAQ = _faqList.where((faq) {
        return faq['question']!.toLowerCase().contains(query) ||
               faq['answer']!.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bantuan / FAQ'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari pertanyaan...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: _filteredFAQ.isEmpty
          ? Center(child: Text('Tidak ada pertanyaan yang sesuai.'))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _filteredFAQ.length,
              itemBuilder: (context, index) {
                final item = _filteredFAQ[index];
                return Card(
                  elevation: 2,
                  child: ExpansionTile(
                    title: Text(item['question']!),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(item['answer']!),
                      )
                    ],
                  ),
                );
              },
            ),
    );
  }
}
