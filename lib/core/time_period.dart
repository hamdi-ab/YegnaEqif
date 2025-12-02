// TimePeriod enum for filtering transactions and budgets by time period
enum TimePeriod { day, week, month, year, all }

// Extension to get display names for TimePeriod values
extension TimePeriodExtension on TimePeriod {
  String get displayName {
    switch (this) {
      case TimePeriod.day:
        return 'Day';
      case TimePeriod.week:
        return 'Week';
      case TimePeriod.month:
        return 'Month';
      case TimePeriod.year:
        return 'Year';
      case TimePeriod.all:
        return 'All Time';
    }
  }
}
