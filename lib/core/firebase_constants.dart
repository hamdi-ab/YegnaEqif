/// Firebase collection names and constants
///
/// Using constants prevents typos and provides a single source of truth
/// for all Firestore collection names used throughout the app.
class FirebaseCollections {
  // User data collections
  static const String users = 'users';
  static const String transactions = 'transactions';
  static const String budgets = 'budgets';
  static const String debts = 'debts';
  static const String categories = 'categories';
  static const String bankCards = 'bankCards';

  // Settings and preferences
  static const String settings = 'settings';
  static const String notifications = 'notifications';

  // User profile
  static const String profile = 'profile';

  // Prevent instantiation
  FirebaseCollections._();
}

/// Firebase field names for consistent access
class FirebaseFields {
  // Common fields
  static const String id = 'id';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String userId = 'userId';

  // User fields
  static const String email = 'email';
  static const String displayName = 'displayName';
  static const String photoURL = 'photoURL';
  static const String name = 'name';

  // Transaction fields
  static const String type = 'type';
  static const String amount = 'amount';
  static const String category = 'category';
  static const String date = 'date';
  static const String bankType = 'bankType';
  static const String description = 'description';

  // Budget fields
  static const String allocatedAmount = 'allocatedAmount';
  static const String spentAmount = 'spentAmount';
  static const String startDate = 'startDate';
  static const String endDate = 'endDate';

  // Debt fields
  static const String personName = 'personName';
  static const String remainingAmount = 'remainingAmount';
  static const String dueDate = 'dueDate';
  static const String payments = 'payments';

  // Category fields
  static const String icon = 'icon';
  static const String color = 'color';

  // Prevent instantiation
  FirebaseFields._();
}
