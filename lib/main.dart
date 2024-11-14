import 'package:flutter/material.dart';
import 'package:drowsiness_mobile/shared/theme.dart';
import 'package:drowsiness_mobile/ui/pages/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drowsiness Detection',
      theme: ThemeData(
        primaryColor: primary, // Warna utama diambil dari theme.dart
        appBarTheme: AppBarTheme(
          backgroundColor: primary,
          titleTextStyle: whiteTextStyle.copyWith(
            fontWeight: bold,
            fontSize: 20,
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: blackTextStyle,
          headlineMedium: blackTextStyle.copyWith(fontWeight: bold, fontSize: 24),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonActiveColor,
            textStyle: whiteTextStyle.copyWith(fontWeight: medium),
          ),
        ),
      ),
      home: SplashPage(), // Mengatur SplashPage sebagai halaman awal
    );
  }
}
