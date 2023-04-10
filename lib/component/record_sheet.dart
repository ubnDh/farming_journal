import 'package:avatar_glow/avatar_glow.dart';
import 'package:farming_journal/controller/recorder_edit_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class RecordSheet extends GetView<RecorderEditController>{
  const RecordSheet({Key? key,}) :super(key:key);
  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "음성으로 입력",
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

  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
        return GestureDetector(
          // onTap: controller.focusOut,
          onTap: (){FocusManager.instance.primaryFocus?.unfocus();},
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Container(
                  color: Colors.black.withOpacity(0.7),
                ),
               Obx(() =>
               Positioned(
                 top: isKeyboardVisible?  Get.height*0.4- MediaQuery.of(context).viewInsets.bottom: Get.height*0.4,
                  child: Container(
                    width: Get.width,
                    height: Get.height*0.6,
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
                                  Text(controller.test.value),
                                  GestureDetector(
                                    onTap: () async {
                                      controller.toggleRecording();
                                    },
                                    child: AvatarGlow(
                                      glowColor: Colors.blue,
                                      endRadius: 65.0,
                                      duration: Duration(milliseconds: 2000),
                                      repeat: true,
                                      showTwoGlows: true,
                                      repeatPauseDuration: Duration(milliseconds: 100),
                                      animate: controller.state.value,
                                      child: Material( // Replace this child with your own
                                        elevation: 8.0,
                                        shape: CircleBorder(),
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(Icons.mic, size: 50,),
                                          radius: 40,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(width:1, color: Colors.grey),
                                    ),
                                    child: TextField(
                                      controller: controller.editingController,
                                      maxLines: 7,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  )
                                ],
                              ),
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
               )
              ],
            ),
          ),
        );
      }
    );
  }
}
