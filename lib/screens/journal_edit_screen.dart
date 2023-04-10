import 'package:farming_journal/component/camera.dart';
import 'package:farming_journal/controller/journal_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_custom.dart';

class JournalEditScreen extends GetView<JournalController>{
  const JournalEditScreen({super.key});

  Widget _category() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('농작업 선택', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
        SizedBox(height: 10,),
        MultiSelectContainer(
          itemsDecoration: MultiSelectDecorations(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6.0)
              ),
              selectedDecoration: BoxDecoration(
                  color: Colors.blue[300],
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(6.0)
              )
          ),
          items: [
            ...List.generate(controller.categorys.length, (index)
            => MultiSelectCard(value: controller.categorys[index], label: controller.categorys[index]))
          ],
          onChange: (allSelectedItems, selectedItem) {
            if(allSelectedItems.isEmpty){
              print("################################");
            }
            controller.categoryList= allSelectedItems;
          },
        ),
        SizedBox(height: 5,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('기타작업', style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500)),
            SizedBox(height: 5,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(width:1, color: Colors.grey),
              ),
              child: TextField(
                maxLines: null,
                controller: controller.categoryController,
                decoration: const InputDecoration(
                  hintText: '직접 입력하세요.',
                  border: InputBorder.none,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _inputWidget(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('일지작성', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
        SizedBox(height: 10,),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(150,70),
                ),
                onPressed: (){
                  controller.editRecord();
                  // Get.bottomSheet(_bottomSheet('사진촬영',_camera()));
                },
                icon: Icon( // <-- Icon
                    Icons.mic,
                    size: 24.0,
                    color: Colors.black
                ),
                label: Text('음성으로 입력',style: TextStyle(fontSize: 15 , color: Colors.black),),
              ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(150,70),
                ),
                onPressed: () {
                  controller.editPhoto();
                },
                icon: Icon( // <-- Icon
                  Icons.photo_camera_outlined,
                  size: 24.0,
                  color: Colors.black,
                ),
                label: Text('사진으로 입력',style: TextStyle(fontSize: 15 , color: Colors.black)),
              ),
            ),
          ],
        ),
        SizedBox(height: 10,),
      ],
    );
  }

  Widget _content() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(width:1, color: Colors.grey),
      ),
      child: TextField(
        onTap: (){
          controller.scrollController.animateTo(120.0, duration: Duration(milliseconds: 500), curve: Curves.ease);
          // controller.test();
        },
        maxLines: 6,
        controller: controller.contentController,
        decoration: const InputDecoration(
          hintText: '업무일지를 작성해주세요',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _btn() {
    return GestureDetector(
      onTap: (){
        controller.submit();
      },
      child: Container(
        alignment: Alignment.center,
        width: Get.width,
        height: 50,
        decoration: BoxDecoration(color: Colors.blue),
        child: Text(controller.isEditMode ? '수정 하기' : '저장 하기',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text('일지작성', style: TextStyle(fontSize: 23 ,fontWeight: FontWeight.bold, color: Colors.black)),
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
      resizeToAvoidBottomInset: true ,
      body: 
        SingleChildScrollView(
          // controller: controller.scrollController,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _category(),
                    SizedBox(height: 20,),
                    _inputWidget(),
                    _content(),
                    SizedBox(height: 25,),
                  ],
                ),
              ),
              _btn(),
              SizedBox(height: Get.mediaQuery.padding.bottom),
            ],
          ),
        ),
    );
  }

}