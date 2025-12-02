/// Centralized validation utilities for form inputs
class Validators {
  // Email validation
  static final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // Amount validation
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    final amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid number';
    }
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  // Budget amount validation
  static String? validateBudgetAmount(String? value, double maxAmount) {
    final basicValidation = validateAmount(value);
    if (basicValidation != null) return basicValidation;

    final amount = double.parse(value!);
    if (amount > maxAmount) {
      return 'Amount cannot exceed $maxAmount';
    }
    return null;
  }

  // Category name validation
  static String? validateCategoryName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Category name is required';
    }
    if (value.length < 2) {
      return 'Category name must be at least 2 characters';
    }
    if (value.length > 50) {
      return 'Category name must be less than 50 characters';
    }
    return null;
  }

  // Bank/Card name validation
  static String? validateBankName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Bank/Card name is required';
    }
    return null;
  }
}
