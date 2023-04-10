import 'package:farming_journal/model/journal.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DataBaseController extends GetxService{
  static DataBaseController get to => Get.find();

  late Database _database;

  Database get database{
    return _database;
  }

  Future<bool> initDataBase() async{
    var databasePath = await getDatabasesPath();
    var dataPath = path.join(databasePath,'smartjounal.db');
    _database = await openDatabase(dataPath, version: 1, onCreate: _onCreateTable);
    return true;
  }

  void _onCreateTable(Database db, int version) async{
    await db.execute('''
      create table ${JournalInfo.tableName}(
        ${JournalInfo.id} integer primary key autoincrement,
        ${JournalInfo.date} text not null,
        ${JournalInfo.content} text not null,      
        ${JournalInfo.category} text not null,
        ${JournalInfo.inputdate} text not null
      )
    ''');
  }

  void closeDataBase() async{
    if(_database != null) await _database!.close();
  }
}