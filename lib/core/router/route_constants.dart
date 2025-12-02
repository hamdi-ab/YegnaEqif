class RouteConstants {
  // Auth Routes
  static const String splash = '/';
  static const String signIn = '/signin';
  static const String signUp = '/signup';

  // App Shell Routes (with bottom nav)
  static const String app = '/app';
  static const String dashboard = '/app/dashboard';
  static const String reports = '/app/reports';
  static const String budget = '/app/budget';
  static const String debt = '/app/debt';

  // Additional Routes
  static const String addTransaction = '/app/add-transaction';
  static const String addBankCard = '/app/add-bank-card';
  static const String addBudget = '/app/add-budget';
  static const String addDebt = '/app/add-debt';
  static const String profile = '/app/profile';
  static const String settings = '/app/settings';

  // Prevent instantiation
  RouteConstants._();
}
