enum DateFilter { today, thisWeek, thisMonth, all }

extension DateFilterExt on DateFilter {
  String get label {
    switch (this) {
      case DateFilter.today: return 'اليوم';
      case DateFilter.thisWeek: return 'هذا الأسبوع';
      case DateFilter.thisMonth: return 'هذا الشهر';
      case DateFilter.all: return 'الكل';
    }
  }

  DateTime? get startDate {
    final now = DateTime.now();
    switch (this) {
      case DateFilter.today:
        return DateTime(now.year, now.month, now.day);
      case DateFilter.thisWeek:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      case DateFilter.thisMonth:
        return DateTime(now.year, now.month, 1);
      case DateFilter.all:
        return null;
    }
  }
}
