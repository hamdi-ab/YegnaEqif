
import 'package:flutter/material.dart';
import 'package:yegna_eqif_new/features/settings/model/user_settings_model.dart';
import 'package:yegna_eqif_new/features/settings/service/settings_service.dart';

class SettingsViewModel extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();

  UserSettingsModel? _userSettings;
  UserSettingsModel? get userSettings => _userSettings;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  SettingsViewModel() {
    loadSettings();
  }

  Future<void> loadSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _userSettings = await _settingsService.getSettings();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveSettings(UserSettingsModel settings) async {
    try {
      await _settingsService.saveSettings(settings);
      _userSettings = settings;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void setThemeMode(ThemeMode themeMode) {
    if (_userSettings != null) {
      final newSettings = UserSettingsModel(themeMode: themeMode);
      saveSettings(newSettings);
    }
  }
}
