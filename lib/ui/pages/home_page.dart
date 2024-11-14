import 'package:flutter/material.dart';
import 'package:drowsiness_mobile/shared/theme.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page', style: whiteTextStyle.copyWith(fontWeight: bold)),
        backgroundColor: primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Teks di tengah halaman
            Text(
              'Welcome to the Home Page!',
              style: blackTextStyle.copyWith(fontSize: 20, fontWeight: medium),
            ),
            SizedBox(height: 30),

            // Tombol pertama
            ElevatedButton(
              onPressed: () {
                // Aksi tombol pertama
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonActiveColor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'Button 1',
                style: whiteTextStyle.copyWith(fontWeight: medium),
              ),
            ),

            SizedBox(height: 20),

            // Tombol kedua
            ElevatedButton(
              onPressed: () {
                // Aksi tombol kedua
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonActiveColor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'Button 2',
                style: whiteTextStyle.copyWith(fontWeight: medium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
