import 'package:farming_journal/controller/database_controller.dart';
import 'package:farming_journal/controller/home_controller.dart';
import 'package:farming_journal/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: Container(
              color: Colors.white,
              child: FutureBuilder(
                  future: DataBaseController.to.initDataBase(),
                  builder: (_, snapshot){
                    if(snapshot.hasError){
                      return const Center(
                        child: Text('sqflite를 지원하지않습니다.'),
                      );
                    }
                    if (snapshot.hasData){
                      Get.put(HomeController());
                      return const HomeScreen();
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
              )
          )
      ),
    );
  }
}
