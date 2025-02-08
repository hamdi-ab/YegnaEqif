import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static Future<void> saveTotalBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('totalBalance', balance);
  }

  static Future<double> getTotalBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('totalBalance') ?? 0.0;
  }

  static Future<void> saveTotalBalanceColor(String color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('totalBalanceColor', color);
  }

  static Future<String> getTotalBalanceColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('totalBalanceColor') ?? '#0000FF'; // Default to blue if no color is saved
  }

  static Future<void> saveCashCardBalance(double balance) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('cashCardBalance', balance);
  }

  static Future<double> getCashCardBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('cashCardBalance') ?? 0.0;
  }

  static Future<void> saveCashCardColor(String color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cashCardColor', color);
  }

  static Future<String> getCashCardColor() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('cashCardColor') ?? '#85bb65'; // Default to black if no color is saved
  }
}
