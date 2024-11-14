import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drowsiness_mobile/shared/theme.dart';
import 'package:http/http.dart' as http;

class CameraPreviewPage extends StatefulWidget {
  @override
  _CameraPreviewPageState createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage> {
  String imageUrl = 'https://example.com/image'; // URL gambar dari API
  bool isOffline = false; // Indikator jika API offline

  // Fungsi untuk mendapatkan gambar dari API
  Future<void> fetchImage() async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        setState(() {
          isOffline = false; // Gambar berhasil diambil
          imageUrl = 'https://example.com/image?timestamp=${DateTime.now().millisecondsSinceEpoch}';
        });
      } else {
        setState(() {
          isOffline = true; // API offline
        });
      }
    } catch (e) {
      setState(() {
        isOffline = true; // Terjadi kesalahan, anggap offline
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImage();
    // Memperbarui gambar setiap 1 detik
    Timer.periodic(Duration(seconds: 1), (timer) => fetchImage());
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Preview', style: whiteTextStyle),
        backgroundColor: primary,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Center(
        child: Container(
          width: deviceWidth,
          height: deviceWidth,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: isOffline
              ? Center(
            child: Text(
              'Sistem Sedang Offline',
              style: greyTextStyle.copyWith(fontSize: 18, fontWeight: medium),
              textAlign: TextAlign.center,
            ),
          )
              : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: deviceWidth,
              height: deviceWidth,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Text(
                    'Sistem Sedang Offline',
                    style: greyTextStyle.copyWith(fontSize: 18, fontWeight: medium),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
