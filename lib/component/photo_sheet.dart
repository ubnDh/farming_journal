import 'dart:io';

import 'package:farming_journal/controller/photo_edit_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PhotoSheet extends GetView<PhotoEditController>{
  const PhotoSheet({Key? key,}) :super(key:key);
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "사진으로 입력",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.close, size: 35,))
      ],
    );
  }

  Widget showImage(){
    if(controller.rxFile.value ==null) {
      return Container(
        alignment: Alignment.center,
        width: 250,
        height: 250,
        child: Text('NoImage'),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(),
            ]
        ),
      );
    }else{
      return Container(
          width: 250,
          height: 250,
          child: Image.file(File(controller.rxFile.value!.path), fit: BoxFit.fill)
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
        return GestureDetector(
          onTap: (){FocusManager.instance.primaryFocus?.unfocus();},
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: [
                Container(
                  color: Colors.black.withOpacity(0.7),
                ),
                Positioned(
                  top: isKeyboardVisible? Get.height*0.25 - MediaQuery.of(context).viewInsets.bottom: Get.height*0.25,
                  child: Container(
                    width: Get.width,
                    height: Get.height*0.75,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _header(),
                              const SizedBox(height: 15),
                              Column(
                                children: [
                                  Obx(() => showImage()),
                                  SizedBox(height: 20,),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            minimumSize: const Size(150,70),
                                          ),
                                          onPressed: (){
                                            controller.getImage(ImageSource.camera);
                                          },
                                          icon: Icon( // <-- Icon
                                            Icons.photo_camera_outlined,
                                            size: 24.0,
                                            color: Colors.black,
                                          ),
                                          label: Text('사진촬영',style: TextStyle(fontSize: 15 , color: Colors.black),),
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          style: OutlinedButton.styleFrom(
                                            minimumSize: const Size(150,70),
                                          ),
                                          onPressed: () {
                                            controller.getImage(ImageSource.gallery);
                                          },
                                          icon: Icon( // <-- Icon
                                            Icons.collections_outlined,
                                            size: 24.0,
                                            color: Colors.black,
                                          ),
                                          label: Text('사진불러오기',style: TextStyle(fontSize: 15 , color: Colors.black)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(width:1, color: Colors.grey),
                                    ),
                                    child: TextField(
                                      controller: controller.editingController,
                                      maxLines: 4,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            controller.submit();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: Get.width,
                            height: 50,
                            decoration: BoxDecoration(color: Colors.blue),
                            child: Text("확인",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    }
}