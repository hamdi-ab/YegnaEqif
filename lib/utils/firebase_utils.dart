import 'package:flutter/material.dart';

String convertColorToHex(Color color) {
  return color.value.toRadixString(16);
}

Color convertHexToColor(String hex) {
  return Color(int.parse('0x$hex'));
}
