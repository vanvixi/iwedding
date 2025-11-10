/// Helper functions for calendar rendering
library;

/// Generate calendar data for a given month
class CalendarData {
  final int year;
  final int month;
  final int specialDay; // Day to show heart icon

  CalendarData({
    required this.year,
    required this.month,
    this.specialDay = 25,
  });

  int get daysInMonth {
    // Month 12 (December) + 1 = month 1 (January) of next year
    // Day 0 = last day of previous month
    final nextMonth = month == 12 ? 1 : month + 1;
    final yearToUse = month == 12 ? year + 1 : year;
    return DateTime(yearToUse, nextMonth, 0).day;
  }

  /// Get the weekday of the first day of the month (1 = Monday, 7 = Sunday)
  int get firstWeekday {
    final firstDay = DateTime(year, month, 1);
    return firstDay.weekday; // 1 = Monday, 7 = Sunday
  }

  /// Number of empty cells before the first day
  int get emptyBefore => firstWeekday - 1; // Monday = 1, so Monday needs 0 empty cells

  /// Get display text for header
  String get headerText => '$month.$year';
}
