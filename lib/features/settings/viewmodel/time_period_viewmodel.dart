import 'package:flutter/material.dart';
import '../../../core/time_period.dart';

/// ViewModel for managing time period selection across the app
///
/// This ViewModel provides a centralized way to manage the selected
/// time period (Week, Month, Year) for Reports, Budget, and Dashboard screens.
class TimePeriodViewModel extends ChangeNotifier {
  TimePeriod _selectedTimePeriod = TimePeriod.month;
  bool _disposed = false;

  TimePeriod get selectedTimePeriod => _selectedTimePeriod;

  /// Set the selected time period and notify listeners
  void setTimePeriod(TimePeriod period) {
    if (_selectedTimePeriod != period) {
      _selectedTimePeriod = period;
      _safeNotifyListeners();
    }
  }

  void _safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  /// Get the number of days in the current period
  int get daysInPeriod {
    final now = DateTime.now();
    switch (_selectedTimePeriod) {
      case TimePeriod.day:
        return 1;
      case TimePeriod.week:
        return 7;
      case TimePeriod.month:
        // Get days in current month
        return DateTime(now.year, now.month + 1, 0).day;
      case TimePeriod.year:
        // Check if leap year
        return (now.year % 4 == 0 &&
                (now.year % 100 != 0 || now.year % 400 == 0))
            ? 366
            : 365;
      case TimePeriod.all:
        // Return approximate days for "all time" (10 years)
        return 3650;
    }
  }

  /// Get a human-readable title for the current period
  String get periodTitle {
    switch (_selectedTimePeriod) {
      case TimePeriod.day:
        return 'Daily';
      case TimePeriod.week:
        return 'Weekly';
      case TimePeriod.month:
        return 'Monthly';
      case TimePeriod.year:
        return 'Yearly';
      case TimePeriod.all:
        return 'All Time';
    }
  }

  /// Get the start date for the current period
  DateTime get periodStartDate {
    final now = DateTime.now();
    switch (_selectedTimePeriod) {
      case TimePeriod.day:
        // Start of current day
        return DateTime(now.year, now.month, now.day);
      case TimePeriod.week:
        // Start of current week (Monday)
        return now.subtract(Duration(days: now.weekday - 1));
      case TimePeriod.month:
        // Start of current month
        return DateTime(now.year, now.month, 1);
      case TimePeriod.year:
        // Start of current year
        return DateTime(now.year, 1, 1);
      case TimePeriod.all:
        // Arbitrary start date for "all time" (10 years ago)
        return DateTime(now.year - 10, 1, 1);
    }
  }

  /// Get the end date for the current period
  DateTime get periodEndDate {
    final now = DateTime.now();
    switch (_selectedTimePeriod) {
      case TimePeriod.day:
        // End of current day
        return DateTime(now.year, now.month, now.day, 23, 59, 59);
      case TimePeriod.week:
        // End of current week (Sunday)
        return now.add(Duration(days: 7 - now.weekday));
      case TimePeriod.month:
        // End of current month
        return DateTime(now.year, now.month + 1, 0);
      case TimePeriod.year:
        // End of current year
        return DateTime(now.year, 12, 31);
      case TimePeriod.all:
        // Current date/time for "all time"
        return now;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
