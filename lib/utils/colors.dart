import 'dart:ui';

import 'package:flutter/material.dart';

class ColorManager {
  static Color background = HexColor.fromHex("#F9F6EE");
  static Color white = Colors.white;
  static Color black = Colors.black;
  static Color blue = Colors.blueAccent;
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll('#', '');
    if(hexColorString.length == 6) {
      hexColorString = "FF$hexColorString";
    }
    return Color(int.parse(hexColorString, radix: 16));

  }
}