import 'package:farming_journal/controller/home_controller.dart';
import 'package:farming_journal/controller/journal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class JournalScreen extends GetView<JournalController>{
  const JournalScreen({Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일지보기', style: TextStyle(fontSize: 23 ,fontWeight: FontWeight.bold, color: Colors.black)),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 80,
        leading: IconButton(
            padding: EdgeInsets.only(left: 20.0),
            onPressed: (){
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios, size: 30, color: Colors.black,)
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() =>
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('날짜', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  Text(controller.rxDt.value, style: TextStyle(fontSize: 16),),
                  Container(margin: EdgeInsets.symmetric(vertical: 20),width: 500,child: Divider(color: Colors.grey[400], thickness: 1.0)),
                  Text('농작업', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  Text(controller.rxCategory.value, style: TextStyle(fontSize: 16),),
                  Container(margin: EdgeInsets.symmetric(vertical: 20),width: 500,child: Divider(color: Colors.grey[400], thickness: 1.0)),
                  Text('일지', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: 5,),
                  Text(controller.rxContent.value, style: TextStyle(fontSize: 16),),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              controller.editJournal();
            },
            child: Container(
              alignment: Alignment.center,
              width: Get.width,
              height: 50,
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("수정 하기",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }
}