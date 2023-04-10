
import 'package:farming_journal/model/journal.dart';
import 'package:flutter/material.dart';

class JournalDataUtil {
  static List<Journal> findJournalListByDateTime(List<Journal> allJournalList,
      DateTime date) {
    print("@@@@@@@journal");
    print(allJournalList.length);
    return allJournalList.where((journal) {
      return (date.month == journal.date.month && date.day == journal.date.day);
    }).toList();
  }
  static bool isComplate(List<Journal> items, DateTime date) {
    var cItems = findJournalListByDateTime(items, date);
    var values = cItems.toList();
    return values.isEmpty;
  }

  static String convertWeekdayToStringValue(int weekDay) {
    switch (weekDay) {
      case 1:
        return '월';
      case 2:
        return '화';
      case 3:
        return '수';
      case 4:
        return '목';
      case 5:
        return '금';
      case 6:
        return '토';
      case 7:
        return '일';
    }
    return '';
  }

  static Color dayToColor(DateTime date, {double opacity = 1}) {
    return date.weekday == DateTime.sunday
        ? Colors.red[600]!.withOpacity(opacity)
        : date.weekday == DateTime.saturday
        ? Colors.blue[600]!.withOpacity(opacity)
        : Colors.black.withOpacity(opacity);
  }
}