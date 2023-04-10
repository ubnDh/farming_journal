import 'package:farming_journal/model/journal.dart';
import 'package:farming_journal/utils/journal_data_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  final Function(PageController) onCalendarCreated;
  final Function(DateTime) onPageChange;
  final Function(DateTime, List<Journal>) onSelectedDate;
  final List<Journal> journalItems;
  final DateTime focusMonth;
  const Calendar({
    Key? key,
    required this.focusMonth,
    required this.onCalendarCreated,
    required this.onPageChange,
    required this.onSelectedDate,
    required this.journalItems,
  }) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  List<Journal> journalItems = [];

  @override
  void initState() {
    super.initState();
  }

  setUpdateItems(){
    journalItems = widget.journalItems;
    _focusedDay = widget.focusMonth;
    update();
  }
  void update() => setState(() {});

  @override
  void didUpdateWidget(Calendar oldWidget) {
    if (journalItems != widget.journalItems) {
      setUpdateItems();
    }
    super.didUpdateWidget(oldWidget);
  }

  Widget _dowHeaderStyle({required String date, required Color color}) {
    return Center(
      child: SizedBox(
        height: 30,
        child: Text(
          date,
          style: TextStyle(color: color, fontSize: 13),
        ),
      ),
    );
  }

  Widget _dayStyle({
    required DateTime date,
    Color? color,
    bool isToday = false,
    bool isSelected = false,
    bool isComplete = false,
  }) {
    var backgroundColor = Colors.white;
    if (isToday) backgroundColor = const Color(0xffbebfc7);
    if (isSelected) backgroundColor = const Color(0xff6d7aaf);
    return Container(
      decoration: BoxDecoration(

      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Center(
            child: Text(
              '${date.day}',
              style: TextStyle(color: isToday ? Colors.white : color, fontSize: 16),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Builder(builder: (context) {
                var items = JournalDataUtil.findJournalListByDateTime(journalItems, date);
                return items.isNotEmpty
                    ? Container(
                      alignment: Alignment.center,
                      height: 15,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(items.length < 4)
                            ...List.generate(items.length, (index) => Text('●', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),))
                          else
                            ...List.generate(3, (index) => Text('●', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepPurple),)),

                          // ...List.generate(items.length, (index) => Icon(Icons.radio_button_unchecked, size: 10,color: Colors.blue,))
                        ],
                      ),
                    )
                    : Container() ;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
  //   return TableCalendar(
  //       focusedDay: _focusedDay ?? DateTime.now(),
  //       firstDay: DateTime.utc(2010,1,1),
  //       lastDay: DateTime.utc(2030,12,31),
  //   );
  // }
    return TableCalendar(
      locale: 'ko_KR',
      rowHeight: 60,
      headerStyle: HeaderStyle( //상단 설정
        titleCentered: true,
        formatButtonVisible: false,   //우측 버튼 가리기
        titleTextStyle: const TextStyle(
          fontSize: 20.0,
        ),
        headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
        leftChevronIcon: const Icon(
          Icons.arrow_left,
          size: 40.0,
        ),
        rightChevronIcon: const Icon(
          Icons.arrow_right,
          size: 40.0,
        ),
      ),
      // availableGestures: AvailableGestures.all,
      daysOfWeekVisible: true,  // 요일정보
      selectedDayPredicate: (day)=> isSameDay(_focusedDay, day),
      focusedDay: _focusedDay ?? DateTime.now(),
      firstDay: DateTime.utc(2020,01,01),
      lastDay: DateTime.utc(2030,12,31),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, date) {
          //월~토
          return _dowHeaderStyle(
            date: JournalDataUtil.convertWeekdayToStringValue(date.weekday),
            color: JournalDataUtil.dayToColor(date),
          );
        },
        defaultBuilder: (context, date, _) => _dayStyle(
          date: date,
          color: JournalDataUtil.dayToColor(date),
          isToday: false,
          isComplete: JournalDataUtil.isComplate(journalItems, date),
        ),
        outsideBuilder: (context, date, _) => _dayStyle(
          date: date,
          color: JournalDataUtil.dayToColor(date, opacity: 0.3),
          isComplete: JournalDataUtil.isComplate(journalItems, date),
        ),
      ),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          widget.onSelectedDate(selectedDay,JournalDataUtil.findJournalListByDateTime(journalItems, selectedDay));
        }
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      onFormatChanged: (format) {},
    );
  }
}
