import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:farming_journal/controller/journal_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart'as http;

class RecorderEditController extends GetxController{
  static RecorderEditController get to => Get.find();

  final FlutterSoundRecorder _audioRecorder = FlutterSoundRecorder();
  bool _isRecorderInitialised = false;
  final invoke_url = 'https://clovaspeech-gw.ncloud.com/external/v1/4665/c514c86fd476a5eba273d35e868776e14eca40e040908fc338223f701141aa4e';
  // # Clova Speech secret key
  final secret = '1eaba489d1e84a619751a8550d64abc5';
  String res = "";
  RxString test = "녹음 대기 중입니다.".obs;
  RxBool state = false.obs;
  TextEditingController editingController = TextEditingController();


  Future toggleRecording() async{
    if(!_isRecorderInitialised){
      test("녹음을 할 수 없습니다");
    }else {
      state(!state.value);
      test(state.value ? '녹음 중 입니다.' : '녹음 대기 중 입니다.');
      if(state.value){
        startRecording();
      }else{
        await stopRecording();
      }
    }
  }
  Future _dialog(String txt){
    return Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
          ),
          title: Row(
            children: [
              Icon(Icons.error),
              SizedBox(width: 10,),
              const Text('Error'),
            ],
          ),
          content: Text(txt),
          actions: [
            TextButton(
              child: const Text("확인"),
              onPressed: () => Get.back(),
            ),
          ],
        )
    );
  }

  @override
  void onInit() async{
    super.onInit();
    final status = await Permission.microphone.request();
    if(status != PermissionStatus.granted) {
      throw RecordingPermissionException('Microphone permission Error');
    }
    final directory = await getApplicationDocumentsDirectory();
    final _path = directory.path;

    _audioRecorder.openAudioSession().then((value) {
      _isRecorderInitialised = true;
    });
  }
  Future<void> startRecording() async {
      if (!_isRecorderInitialised) return;
      await _audioRecorder!.startRecorder(toFile: 'recording.aac');

  }
  Future<void> stopRecording() async {
      if (!_isRecorderInitialised) return;
      final path = await _audioRecorder!.stopRecorder();
      String res = await reqUpload(path! , 'sync');
      if(res == "error" || res =="retry"){
        _dialog('녹음이 정상적으로 되지 않았습니다.\n다시 시도해주세요.');
      }else{
        editingController.text = editingController.text+res;
      }
  }

  Future reqUpload(String file, String completion) async {
    final request_body = {
      'language': 'ko-KR',
      'completion': completion,
      'callback': '',
      'userdata': '',
      'wordAlignment': '',
      'fullText': '',
      'forbiddens': '',
      'boostings': '',
      'diarization': '',
    };
    final headers = {
      'Accept': 'application/json;UTF-8',
      'X-CLOVASPEECH-API-KEY': secret
    };
    final request = http.MultipartRequest('POST', Uri.parse(invoke_url + '/recognizer/upload'))
      ..headers.addAll(headers)
      ..fields['params'] = json.encode(request_body)
      ..files.add(await http.MultipartFile.fromPath('media', file));
    final streamedResponse = await request.send();
    if(streamedResponse.statusCode == 200){
      var response = await http.Response.fromStream(streamedResponse);
      var result = jsonDecode(utf8.decode(response.bodyBytes));
      result['text'].replaceAll(RegExp('\\s'),"") != '' ? res = result['text'] : res = 'retry';
      return res;
    }else{
      return 'error';
    }
  }

  void submit(){
    JournalController.to.contentController.text = JournalController.to.contentController.text + editingController.text;
    Get.back();
  }

  @override
  void onClose() {
    _audioRecorder!.closeAudioSession();
    editingController.clear();
    _isRecorderInitialised = false;
    super.onClose();
  }
}