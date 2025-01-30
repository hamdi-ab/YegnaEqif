import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the possible time periods
enum TimePeriod { week, month, year }

// Create a StateProvider to manage the selected time period
final timePeriodProvider = StateProvider<TimePeriod>((ref) {
  return TimePeriod.week; // Default value
});
