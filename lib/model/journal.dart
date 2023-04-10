
class JournalInfo{
  static String tableName = 'journal';
  static String id = '_id';
  static String date = 'date';
  static String content = 'content';
  static String category = 'category';
  static String inputdate = 'inputdate';
}

class Journal{

  final int? id;
  final String content;
  final List<String> category;
  final DateTime date;
  final DateTime inputdate;

  Journal({
    this.id,
    required this.content,
    required this.category,
    required this.date,
    required this.inputdate,
  });

  Map<String, dynamic> toJson(){
    return {
      JournalInfo.id : id,
      JournalInfo.content : content,
      JournalInfo.category : category.join(','),
      JournalInfo.date : date.toIso8601String(),
      JournalInfo.inputdate : inputdate.toIso8601String(),
    };
  }
  factory Journal.fromJson(Map<String, dynamic> json){
    return Journal(
      id : json[JournalInfo.id]  as int?,
      content: json[JournalInfo.content as String],
      category: json[JournalInfo.category].split(','),
      date:DateTime.parse(json[JournalInfo.date]as String),
      inputdate: json[JournalInfo.inputdate] == null ? DateTime.now() : DateTime.parse(json[JournalInfo.inputdate] as String),
    );
  }

  Journal clone({
    int? id,
    DateTime? date,
    String? content,
    List<String>? category,
    DateTime? inputdate,
  }){
    return Journal(id : id ?? this.id,content: content ?? this.content , category: category ?? this.category, date: date ?? this.date, inputdate: inputdate ?? this.inputdate);
  }
}