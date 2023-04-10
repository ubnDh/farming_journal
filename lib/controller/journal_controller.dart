import 'package:farming_journal/component/photo_sheet.dart';
import 'package:farming_journal/component/record_sheet.dart';
import 'package:farming_journal/controller/home_controller.dart';
import 'package:farming_journal/controller/photo_edit_controller.dart';
import 'package:farming_journal/controller/recorder_edit_controller.dart';
import 'package:farming_journal/model/journal.dart';
import 'package:farming_journal/repository/journal_repository.dart';
import 'package:farming_journal/screens/journal_edit_screen.dart';
import 'package:farming_journal/screens/journal_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class JournalController extends GetxController {
  static JournalController get to => Get.find();
  bool isEditMode = false;
  bool isLoaded = false;
  int editJournalId = -1;
  late DateTime date;
  TextEditingController contentController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  List<String> categoryList = [];
  RxString rxContent = ''.obs;
  RxString rxCategory = ''.obs;
  RxString rxDt = ''.obs;
  late ScrollController scrollController;

  final RxList<String> selectedCategories = <String>[].obs;

  final categorys =
  [
    '경운정지',
    '병해충방지',
    '김매기',
    '묘판관리',
    '비닐 피복 및 흙덮기',
    '비닐피복 및 흙덮기 제거',
    '물주기',
    '선별 및 포장',
    '솎아내기',
    '수확',
    '아주심기',
    '제초',
    '운반및저장',
    '웃 비료주기',
    '종자준비 및 소독',
    '탈곡',
    '퇴비 및 밑비료주기',
    '파종',
    '건조',
    '묘상준비 및 설치'
  ];


  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    date = HomeController.to.currentDate;
    if(Get.arguments!= null && Get.arguments['journal'] != null){
      var journal = (Get.arguments['journal'] as Journal);
      editJournalId = journal.id!;
      isEditMode = true;
      contentController.text = journal.content;
      categoryList = journal.category;
      date = journal.date;
      rxContent(journal.content);
      rxCategory(journal.category.join(', '));
      rxDt(DateFormat("yyyy년 MM월 dd일").format(journal.date));
    }
    scrollController = ScrollController();
    isLoaded = true;
  }
  @override
  void onClose(){
    scrollController.dispose();
  }

  Future<void> submit() async {
    var content = contentController.text;
    var category = categoryList;
    var etc = categoryController.text;
    if(etc != null && etc != ''){
      category.add(etc);
    }
    try {
      if (content.trim() != '') {
        var _journal = Journal(
          content: content,
          category: category,
          date: HomeController.to.currentDate,
          inputdate: DateTime.now(),
        );

        var result = -1;
        if (isEditMode) {
          result = await JournalRepository.update(_journal.clone(id: editJournalId));
        } else {
          result = await JournalRepository.create(_journal);
        }
        if (result > 0) {
          HomeController.to.refreshCurrentMonth();
          rxCategory(category.join(', '));
          rxContent(content);
          back();
          // Get.off(JournalScreen(), arguments: {'journal':_journal},
          //     binding: BindingsBuilder(() { Get.put(JournalController());}));
        }

      }
    } catch (e) {
      print(e);
    }

  }

  void back() {
    Get.back();
  }
  Future<void> editJournal() async {
    Get.to(() => const JournalEditScreen(),
      arguments: {'journal': Get.arguments['journal']},
      binding: BindingsBuilder(() { Get.put(JournalController());},
      ),
    );
  }

  Future<void> editRecord() async {
    Get.to(() => const RecordSheet(),
      binding: BindingsBuilder(() { Get.put(RecorderEditController());},
      ),
    );
  }
  Future<void> editPhoto() async {
    Get.to(() => const PhotoSheet(),
      binding: BindingsBuilder(() { Get.put(PhotoEditController());},
      ),
    );
  }
  void test(){
    print("@@@@@@@@@@@@@@@@@@@@@@");
    scrollController.animateTo(500.0, duration: Duration(milliseconds: 500), curve: Curves.ease);
  }
}