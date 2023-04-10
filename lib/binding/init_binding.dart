import 'package:farming_journal/controller/database_controller.dart';
import 'package:get/get.dart';

class InitBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(DataBaseController());
  }
}