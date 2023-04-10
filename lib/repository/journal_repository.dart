import 'package:farming_journal/controller/database_controller.dart';
import 'package:farming_journal/model/journal.dart';

class JournalRepository {
  static Future<int> create(Journal journal) async{
    return await DataBaseController.to.database.insert(JournalInfo.tableName, journal.toJson());
  }

  static Future<int> update(Journal journal) async{
    try {
      return await DataBaseController.to.database.update(
          JournalInfo.tableName, journal.toJson(), where: '${JournalInfo.id}=?',
          whereArgs: [journal.id]);
    }catch(e){
      print(e);
      return 0;
    }
  }

  static Future<int> delete(Journal journal) async{
    return await DataBaseController.to.database.delete(JournalInfo.tableName, where: '${JournalInfo.id} = ? ', whereArgs: [journal.id]);
  }

  static Future<int> deleteAll() async{
    return await DataBaseController.to.database.delete(JournalInfo.tableName, where: '1=1 ');
  }
  static Future<List<Journal>> getListAll() async{
    var result = await DataBaseController.to.database.query(JournalInfo.tableName);
    return result.map((data) => Journal.fromJson(data)).toList();
  }
  static Future<List<Journal>> findByDateRange(DateTime startDate,DateTime endDate) async{
    List<dynamic> queryValues = [
      startDate.toIso8601String(),
      endDate.toIso8601String()
    ];
    var query = '''
              select 
              *
              from ${JournalInfo.tableName} 
              where ${JournalInfo.date} >= ? and ${JournalInfo.date} <= ? ''';
    var results = await DataBaseController.to.database.rawQuery(
      query,
      queryValues,
    );
    return results.map((data) => Journal.fromJson(data)).toList();
  }
}