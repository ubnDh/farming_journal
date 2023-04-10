import 'package:farming_journal/component/calendar.dart';
import 'package:farming_journal/component/calendar_table.dart';
import 'package:farming_journal/component/journal_card.dart';
import 'package:farming_journal/controller/journal_controller.dart';
import 'package:farming_journal/screens/journal_edit_screen.dart';
import 'package:flutter/material.dart';
import 'package:farming_journal/controller/home_controller.dart';
import 'package:get/get.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({Key? key}) : super(key: key);

  Widget _journalListWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 30, left: 10 , right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '일지 리스트',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => controller.currentJournalListByCurrentDate.isEmpty
            ? _emptyMessageWidget('작성된 일지가 없습니다.')
            : Column(
              children: [
                ...List.generate(
                    controller.currentJournalListByCurrentDate.length,
                    (index) => JournalCard(
                      journal : controller.currentJournalListByCurrentDate[index],
                      onViewJournal : controller.viewJournal,
                    ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _emptyMessageWidget(String message){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: SizedBox(
        height: 180,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 40.0,),
            const SizedBox(height: 15),
            Text(
              message,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            )
          ]
        ),
      ),
    );
  }

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('스마트 영농 일지', style: TextStyle(fontSize: 23 ,fontWeight: FontWeight.bold, color: Colors.black)),
            Text('일지를 편하게 관리하세요!', style: TextStyle(fontSize: 17 , color: Colors.black26)),
          ],
        ),
        toolbarHeight: 90,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Calendar(
              //     focusMonth: controller.headerDate.value,
              //     onCalendarCreated: controller.onCalendarCreated,
              //     onPageChange: controller.onPageChange,
              //     onSelectedDate: controller.onSelectedDate,
              //     journalItems: controller.currentMonthJournalList
              // ),
              CalendarTable(),
              _journalListWidget()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
          onPressed: () {
            Get.to(
              () => JournalEditScreen(),
              binding: BindingsBuilder(()
                {
                  Get.put(JournalController());
                }
              )
            );
          },
          child: Center(
            // child: Icon(Icons.edit_note),
            child: Text('일지작성'),
          )
      )
    );
  }

}