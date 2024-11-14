import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Color Style
Color primary = const Color(0xff6699CC);
LinearGradient background = LinearGradient(
  colors: [
    const Color(0xff66CCFF),
    const Color(0xff0099FF),
  ],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);
Color whiteColor = const Color(0xffFFFFFF);
Color redColor = const Color(0xffFF4854);
Color buttonActiveColor = const Color(0xff0099FF);
Color buttonDisableColor = const Color(0xff6D6D6D);
Color transparentBackground = const Color(0xff66CCFF);

//TextStyle
TextStyle blackTextStyle = GoogleFonts.poppins(color: Colors.black);

TextStyle whiteTextStyle = GoogleFonts.poppins(color: Colors.white);

TextStyle greyTextStyle = GoogleFonts.poppins(color: Colors.grey);

TextStyle blueTextStyle = GoogleFonts.poppins(color: Colors.blue);

TextStyle greenTextStyle = GoogleFonts.poppins(color: Colors.green);

//font weight atau ketebalan huruf
FontWeight superlight = FontWeight.w100;
FontWeight light = FontWeight.w300;
FontWeight reguler = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semibold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extrabold = FontWeight.w800;
FontWeight black = FontWeight.w900;
