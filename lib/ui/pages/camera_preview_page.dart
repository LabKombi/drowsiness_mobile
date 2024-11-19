import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CameraPreviewPage extends StatefulWidget {
  @override
  _CameraPreviewPageState createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage> {
  String baseImageUrl = 'http://192.168.179.164/photo.jpg';
  String imageUrl = '';
  bool isOffline = false;
  Timer? _timer;

  Future<void> fetchImage() async {
    try {
      final newUrl =
          '$baseImageUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}';
      final response = await http.get(Uri.parse(newUrl));

      if (response.statusCode == 200) {
        setState(() {
          isOffline = false;
          imageUrl = newUrl;
        });
      } else {
        setState(() {
          isOffline = true;
        });
      }
    } catch (e) {
      setState(() {
        isOffline = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchImage();
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
              key: ValueKey(imageUrl), // Tambahkan Key unik
              fit: BoxFit.cover,
              width: deviceWidth,
              height: deviceWidth,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Text(
                    'Sistem Sedang Offline',
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
