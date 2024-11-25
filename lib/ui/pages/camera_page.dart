import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:drowsiness_mobile/shared/config.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final String feedUrl = "https://io.adafruit.com/api/v2/${Config.username}/feeds?x-aio-key=${Config.feedKey}"; // Ganti dengan URL yang sesuai
  Image? image;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Panggil fetchImage saat pertama kali dan secara periodik
    fetchImage();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      fetchImage();
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Pastikan timer dihentikan saat halaman ditutup
    super.dispose();
  }

  Future<void> fetchImage() async {
    try {
      final response = await http.get(Uri.parse(feedUrl));

      if (response.statusCode == 200) {
        // Parsing response JSON
        List<dynamic> feeds = json.decode(response.body);

        // Mencari feed dengan id tertentu
        var targetFeed = feeds.firstWhere(
              (feed) => feed['id'] == 2940873, // Ganti dengan ID feed yang diinginkan
          orElse: () => null,
        );

        if (targetFeed != null && targetFeed['last_value'] != null) {
          // Mendapatkan last_value yang berisi gambar dalam Base64
          String base64Image = targetFeed['last_value'];

          // Decode Base64 menjadi bytes
          Uint8List bytes = base64Decode(base64Image);

          // Update state untuk menampilkan gambar
          setState(() {
            image = Image.memory(bytes);
          });
        } else {
          print("Feed tidak ditemukan atau last_value kosong");
        }
      } else {
        print('Failed to load feed data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width * 0.8;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera Preview"),
      ),
      body: Center(
        child: image == null
            ? const CircularProgressIndicator()
            : Container(
          width: deviceWidth,
          height: deviceWidth,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: image,
          ),
        ),
      ),
    );
  }
}
