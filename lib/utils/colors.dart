import 'dart:ui';

import 'package:flutter/material.dart';

class ColorManager {
  static Color containerLight = HexColor.fromHex("#F9F6EE");
  static Color backgroundDark = Colors.black;
  static Color containerDark = HexColor.fromHex("#2C3335");
  static Color backgroundLight = Colors.white;
  static Color black = Colors.black;
  static Color white = Colors.white;
  static Color blue = Colors.blueAccent;
  static Color blueDark = HexColor.fromHex("#4834DF");
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