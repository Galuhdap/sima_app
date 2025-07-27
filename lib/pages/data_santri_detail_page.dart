import 'package:flutter/material.dart';
import 'package:inventory_app/services/network_constans.dart';

class DataSantriDetailPage extends StatefulWidget {
  final String nama;
  final String noTelp;
  final String tanggal;
  final String alamat;
  final String kelas;
  final String kamar;
  final String gambar;

  const DataSantriDetailPage({
    super.key,
    required this.nama,
    required this.noTelp,
    required this.tanggal,
    required this.alamat,
    required this.kamar,
    required this.kelas,
    required this.gambar,
  });

  @override
  State<DataSantriDetailPage> createState() => _DataSantriDetailPageState();
}

class _DataSantriDetailPageState extends State<DataSantriDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Santri', style: TextStyle(color: Colors.white)),
        elevation: 4,
        shadowColor: Colors.black54,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Center(
              child: Container(
                width: 100,
                height: 100,
                color: Colors.red,
                child: Image.network(
                  'http://${NetworkConstants.BASE_URL}/storage/santri/${widget.gambar}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'No Kamar',
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
              ),
            ),
            Center(
              child: Text(
                widget.kamar,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Center(
              child: Text(
                widget.nama,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        'No. Telp Wali Santri:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(widget.noTelp, style: TextStyle(fontSize: 15)),
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
                        'Tanggal Masuk:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(widget.tanggal),
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
                        'Alamat:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.alamat,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
                        'Kelas:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(widget.kelas, style: TextStyle(fontSize: 15)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
