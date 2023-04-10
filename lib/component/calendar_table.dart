import 'package:farming_journal/controller/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarTable extends StatelessWidget {
  CalendarController calendarController = Get.put(CalendarController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          focusedDay: DateTime.now(),
          firstDay: DateTime(2010, 01, 01),
          lastDay: DateTime(2030, 12, 32),
          eventLoader: (day) => calendarController.getEventsForDay(day),
          onDaySelected: (day, events) {
            // 선택한 날짜에 이벤트를 추가하는 화면으로 이동
            // Get.to(EventAddScreen(day: day));
          },
          onPageChanged: (focusedDay) => print(focusedDay),
        ),
      ],
    );
  }
}