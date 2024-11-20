import 'dart:async';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final String baseUrl = "https://i.pinimg.com/1200x/fb/8f/db/fb8fdbff65307bbe14e5e5876363e91a.jpg"; // Ganti dengan URL API Anda
  String imageUrl = "";
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Atur URL awal
    imageUrl = _generateImageUrl();
    // Jalankan timer untuk memperbarui URL setiap 1 detik
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        imageUrl = _generateImageUrl();
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Pastikan timer dihentikan saat halaman ditutup
    super.dispose();
  }

  String _generateImageUrl() {
    // Tambahkan query parameter acak agar cache tidak digunakan
    return "$baseUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}";
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Stream"),
      ),
      body: Center(
        child: imageUrl.isNotEmpty
            ? Container(
          width: deviceWidth,
          height: deviceWidth,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              key: ValueKey(imageUrl), // Memastikan widget diperbarui
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Text(
                    "Failed to load image",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                );
              },
            ),
          ),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
