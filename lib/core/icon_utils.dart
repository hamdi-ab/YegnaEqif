import 'package:flutter/material.dart';

String convertIconToString(IconData icon) {
  return '${icon.codePoint},${icon.fontFamily},${icon.fontPackage ?? ''}';
}

IconData convertStringToIcon(String iconString) {
  final parts = iconString.split(',');
  if (parts.length >= 2) {
    final codePoint = int.tryParse(parts[0]);
    final fontFamily = parts[1];
    final fontPackage = parts.length > 2 ? parts[2] : null;
    if (codePoint != null && fontFamily.isNotEmpty) {
      return IconData(codePoint, fontFamily: fontFamily, fontPackage: fontPackage);
    }
  }
  return Icons.help; // Default icon in case of an error
}


