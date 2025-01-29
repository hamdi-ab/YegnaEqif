import 'package:flutter/material.dart';

String convertIconToString(IconData icon) {
  return icon.toString();
}

IconData convertStringToIcon(String iconString) {
  // Example for converting back to icons, this will need to be expanded
  if (iconString == 'Icons.fastfood') {
    return Icons.fastfood;
  }
  return Icons.help; // Default icon
}
