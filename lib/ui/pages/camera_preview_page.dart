import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CameraPreviewPage extends StatefulWidget {
  @override
  _CameraPreviewPageState createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage> {
  // URL gambar, bisa diganti dengan API gambar dinamis
  String baseImageUrl =
      'https://i.pinimg.com/1200x/fb/8f/db/fb8fdbff65307bbe14e5e5876363e91a.jpg'; // URL fallback statis untuk pengujian
  String imageUrl = '';
  bool isOffline = false;
  Timer? _timer;
  bool _isFetching = false;

  // Fungsi untuk mengambil gambar dari API
  Future<void> fetchImage() async {
    if (_isFetching) return; // Hindari pemanggilan ganda
    _isFetching = true;

    try {
      // Tambahkan timestamp untuk menghindari cache
      final newUrl =
          '$baseImageUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}';
      final response = await http.get(Uri.parse(newUrl));

      // Debug log respons
      print("Response status: ${response.statusCode}");
      print("Response body length: ${response.body.length}");

      if (response.statusCode == 200) {
        setState(() {
          isOffline = false;
          imageUrl = newUrl; // URL dengan timestamp
        });
      } else {
        setState(() {
          isOffline = true;
        });
      }
    } catch (e) {
      print("Error fetching image: $e");
      setState(() {
        isOffline = true;
      });
    } finally {
      _isFetching = false;
    }
  }

  @override
  void initState() {
    super.initState();
    // Inisialisasi gambar pertama
    fetchImage();
    // Timer untuk memperbarui gambar setiap detik
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => fetchImage());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: Text('Camera Preview'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
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
              style: TextStyle(color: Colors.grey, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          )
              : ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              key: ValueKey(imageUrl), // Pastikan widget diperbarui
              fit: BoxFit.cover,
              width: deviceWidth,
              height: deviceWidth,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Text(
                    'Gagal Memuat Gambar',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
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
