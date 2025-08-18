
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_eqif_new/features/settings/model/user_settings_model.dart';

class SettingsService {
  Future<UserSettingsModel> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('themeMode') ?? 'system';
    final themeMode = ThemeMode.values.firstWhere((e) => e.toString() == 'ThemeMode.$themeModeString');
    return UserSettingsModel(themeMode: themeMode);
  }

  Future<void> saveSettings(UserSettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', settings.themeMode.toString().split('.').last);
  }
}
