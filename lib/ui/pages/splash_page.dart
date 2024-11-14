import 'dart:async';
import 'package:flutter/material.dart';
import 'package:drowsiness_mobile/shared/theme.dart';
import 'package:drowsiness_mobile/ui/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _animation;

  @override
  void initState() {
    super.initState();

    // Durasi animasi logo
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    // Scale animasi
    _animation = CurvedAnimation(
      parent: _controller!,
      curve: Curves.easeInOut,
    );

    _controller!.forward();

    // Menjalankan splash screen selama 2 detik, kemudian ke HomePage
    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary, // Warna dari theme.dart
      body: Center(
        child: ScaleTransition(
          scale: _animation!,
          child: Image.asset('assets/logo.png', width: 100, height: 100), // Ganti ukuran sesuai kebutuhan
        ),
      ),
    );
  }
}
