import 'package:flutter/material.dart';

String convertIconToString(IconData icon) {
  return '${icon.codePoint},${icon.fontFamily}';
}

IconData convertStringToIcon(String iconString) {
  final parts = iconString.split(',');
  if (parts.length == 2) {
    final codePoint = int.tryParse(parts[0]);
    final fontFamily = parts[1];
    if (codePoint != null && fontFamily.isNotEmpty) {
      return IconData(codePoint, fontFamily: fontFamily);
    }
  }
  return Icons.help; // Default icon in case of an error
}

