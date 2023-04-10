import 'dart:collection';

import 'package:farming_journal/model/journal.dart';
import 'package:farming_journal/repository/journal_repository.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarController extends GetxController{
  static CalendarController get to => Get.find();
  RxList<Journal> journals = <Journal>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }
  List<Journal> getEventsForDay(DateTime day) {
    Map<DateTime, List<Journal>> journalByDate = eventsGroupedByDate();
    print("************");
    print(day);
    print(journalByDate[day]);
    return journalByDate[day] ?? [];
  }

  Future<void> loadEvents() async {
    var res = await JournalRepository.getListAll();
    print("###################");
    for(Journal j in res){
      print(j.date);
    }
    print("###################");
    journals.assignAll(res);
  }

  Map<DateTime, List<Journal>> eventsGroupedByDate() {
    Map<DateTime, List<Journal>> journalByDate = {};
    for (Journal journal in journals) {
      DateTime journalDate = DateTime(journal.date.year, journal.date.month, journal.date.day);
      if(journalByDate[journalDate]== null){
        journalByDate[journalDate] = [journal];
      }else{
        journalByDate[journalDate]!.add(journal);
      }
    }
    return journalByDate;
  }

}