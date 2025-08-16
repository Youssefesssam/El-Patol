import 'package:flutter/material.dart';

abstract class AppColors {
  static Color mainColor = Colors.indigo.shade600;
  static Color? secColor = Colors.indigo.shade500;
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color? darkgrey = Colors.grey[900];
  static Color? lightgrey = Colors.grey;
  static List<Color> appBarColor = [
    Colors.blue,
    Colors.indigo.shade900,
  ];
  static List<Color> smoothColorTeal = [
    Colors.deepPurple.shade800,
    Colors.blue,
    Colors.indigo.shade600,
  ];
  static List<Color> backGround = [
    Colors.indigo.withOpacity(0.4),
    Colors.blueGrey.withOpacity(0.4),
    Colors.blue.withOpacity(0.4),
  ];
}
