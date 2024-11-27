import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:drowsiness_mobile/shared/theme.dart';

import 'camera_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final DatabaseReference _databaseRef =
  FirebaseDatabase.instance.ref().child('pengendara'); // Menggunakan ref()
  String _status = 'not';
  bool _isWarningOn = false;

  late AnimationController _blinkController;

  @override
  void initState() {
    super.initState();
    _fetchStatusFromFirebase();

    // Animasi kelap-kelip
    _blinkController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Waktu animasi lebih cepat
    )..repeat(reverse: true); // Loop animasi bolak-balik
  }

  @override
  void dispose() {
    _blinkController.dispose(); // Membersihkan controller saat widget dihancurkan
    super.dispose();
  }

  void _fetchStatusFromFirebase() {
    _databaseRef.onValue.listen((event) {
      final String? status = event.snapshot.value as String?;
      setState(() {
        _status = status ?? 'not';
        _isWarningOn = (_status == 'sleepy' || _status == 'yawn');
      });
    });
  }

  void _toggleWarning() {
    if (_isWarningOn) {
      _databaseRef.set('not'); // Set status di Firebase menjadi "not"
    }
  }

  String _getStatusText() {
    switch (_status) {
      case 'sleepy':
        return "Warning, Anda terdeteksi mengantuk";
      case 'yawn':
        return "Warning, Anda terdeteksi kelelahan";
      case 'not':
      default:
        return "Sistem deteksi sedang bekerja";
    }
  }

  Color _getTextColor() {
    if (_status == 'sleepy' || _status == 'yawn') {
      return Colors.red;
    }
    return Colors.black;
  }

  bool _shouldBlink() {
    return _status == 'sleepy' || _status == 'yawn';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: whiteTextStyle.copyWith(fontWeight: bold),
        ),
        backgroundColor: primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Teks di tengah halaman
            AnimatedBuilder(
              animation: _blinkController,
              builder: (context, child) {
                return Opacity(
                  opacity: _shouldBlink() ? _blinkController.value : 1.0, // Efek kelap-kelip
                  child: Text(
                    _getStatusText(),
                    style: blackTextStyle.copyWith(
                      fontSize: 22, // Ukuran font diperbesar agar lebih jelas
                      fontWeight: FontWeight.bold, // Tulisan lebih tebal
                      color: _getTextColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
            SizedBox(height: 30),

            // Tombol pertama
            ElevatedButton(
              onPressed: _isWarningOn ? _toggleWarning : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isWarningOn ? Colors.green : redColor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                disabledBackgroundColor: redColor, // Warna tombol saat disabled
              ),
              child: Text(
                _isWarningOn ? 'Peringatan: ON' : 'Peringatan: OFF',
                style: whiteTextStyle.copyWith(fontWeight: medium),
              ),
            ),

            SizedBox(height: 20),

            // Tombol kedua
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CameraPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonActiveColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'Preview Camera',
                style: whiteTextStyle.copyWith(fontWeight: medium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
