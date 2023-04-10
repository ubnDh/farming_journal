import 'dart:convert';
import 'dart:io';

import 'package:farming_journal/controller/journal_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class PhotoEditController extends GetxController {

  TextEditingController editingController = TextEditingController();
  final picker = ImagePicker();
  final api_url = 'https://mh5ezl1c16.apigw.ntruss.com/custom/v1/20865/6152b42c1a0b1128e5b0f4760d5f9105702b514296ac23eaaa58f291db5f3a23/general';
  final secret_key = 'RVpkT25tUm1oT0FoaEtrTnNGbEN5YUVBV1Vma3FLcm4=';
  Rx<File?> rxFile = Rx<File?>(null);

  Future getImage(ImageSource imageSource) async{
    var image = await picker.pickImage(source: imageSource);
    if(image == null){
      //사진 촬영 또는 선택 취소시
    }else{
      rxFile(File(image.path));
      final request_json = {
        'images': [
          {
            'format': 'jpg',
            'name': 'demo'
          }
        ],
        'requestId': 'your-request-id',
        'version': 'V2',
        'timestamp': DateTime
            .now()
            .millisecondsSinceEpoch
      };

      final payload = {'message': jsonEncode(request_json)};
      final headers = {'X-OCR-SECRET': secret_key};
      final request = http.MultipartRequest('POST', Uri.parse(api_url))
        ..headers.addAll(headers)
        ..files.add(await http.MultipartFile.fromPath('file', image!.path))
        ..fields.addAll(payload);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final res_json = jsonDecode(response.body);
        final images = res_json['images'];
        String str = "";
        for (final image in images) {
          if (image['inferResult'] == 'SUCCESS') {
            for (final field in image['fields']) {
              str = str + " " +field['inferText'];
            }
            editingController.text = str;
          } else {
            print('text 변환을 성공하지 못했습니다.');
            print(image['message']);
          }
        }
      } else {
        print(response.statusCode);
        print('서버에서 작업을 완료하지 못했습니다.');
      }
    }
  }
  void submit(){
    JournalController.to.contentController.text = JournalController.to.contentController.text + editingController.text;
    Get.back();
  }
}