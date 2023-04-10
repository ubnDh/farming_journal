import 'package:farming_journal/controller/journal_controller.dart';
import 'package:farming_journal/repository/journal_repository.dart';
import 'package:farming_journal/screens/journal_edit_screen.dart';
import 'package:farming_journal/screens/journal_screen.dart';
import 'package:farming_journal/utils/journal_data_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:farming_journal/model/journal.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  Rx<Size> calendarSize = Size.zero.obs;
  GlobalKey calendarKey = GlobalKey();
  GlobalKey calendarHeaderKey = GlobalKey();
  Rx<DateTime> headerDate = DateTime.now().obs;
  RxList<Journal> currentMonthJournalList = <Journal>[].obs;
  RxList<Journal> currentJournalListByCurrentDate = <Journal>[].obs;
  DateTime currentDate = DateTime.now();
  RxList<Journal> events = <Journal>[].obs;


  @override
  void onInit() {
    super.onInit();
    getList();
    // refreshCurrentMonth();
  }

  void getList()async{
    var findCurrentMonthJournalList = await JournalRepository.getListAll();
    currentMonthJournalList(findCurrentMonthJournalList);
  }
  void deleteAll() async{
    await JournalRepository.deleteAll();
  }

  void onCalendarCreated(PageController pageController) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      var calendarSizeData = getRenderBoxSize(calendarKey);
      if (calendarSizeData != null) {
        calendarSize(calendarSizeData);
      }
    });
  }

  Size? getRenderBoxSize(GlobalKey key) {
    if (key.currentContext != null) {
      var renderBox = key.currentContext!.findRenderObject() as RenderBox;
      var translation = renderBox.getTransformTo(null).getTranslation();
      return Size(0, renderBox.size.height + translation.y + 20);
    }
    return null;
  }

  void refreshCurrentMonth() async {
    await onPageChange(currentDate);
    print("##############");
    print(currentDate);
    print("##############");
    var list = JournalDataUtil.findJournalListByDateTime(currentMonthJournalList, currentDate);
    onSelectedDate(currentDate, list);
  }

  void onSelectedDate(DateTime date, List<Journal> todayJournalList) {
    currentDate = date;
    currentJournalListByCurrentDate.clear();
    for (var journal in todayJournalList) {
      currentJournalListByCurrentDate.add(journal);
    }
  }



  Future<void> onPageChange(DateTime date) async {
    var startDate = DateTime(date.year, date.month, 1);
    var endDate = DateTime(date.year, date.month + 1, 0);
    var findCurrentMonthJournalList = await JournalRepository.findByDateRange(startDate, endDate);
    currentMonthJournalList(findCurrentMonthJournalList);
    headerDate(date);
  }

  Future<void> deleteJournalItem(Journal journal) async {
    await JournalRepository.delete(journal);
    refreshCurrentMonth();
  }

  Future<void> viewJournal(Journal journal) async{
    Get.to(() => const JournalScreen(),
      arguments: {'journal':journal},
      binding: BindingsBuilder(() { Get.put(JournalController());},
      ),
    );
  }
}