import 'package:covoice/database/covoice_database.dart';
import 'package:covoice/entities/lesson.dart';
import 'package:sqflite/sqlite_api.dart';

//TODO: Entity annotation
class LessonModule {
  static const tableName = 'lesson_module';

  int? id;
  String title;
  String folderName;
  bool completed;
  List<Lesson> lessons;

  LessonModule({this.id, required this.title, required this.folderName, this.lessons = const [], this.completed = false});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'folder_name': folderName,
      'completed': completed ? 1 : 0,
    };
  }

  static LessonModule fromMap(Map<String, dynamic> map){
    List<Lesson> lessonList = [];
    if(map.containsKey('lessons')){
      lessonList = (map['lessons'] as List<Map<String, dynamic>>).map((lessonMap) => Lesson.fromMap(lessonMap)).toList();
    }
    
    return LessonModule(
      id: map['id'], 
      title: map['title'], 
      folderName: map['folder_name'], 
      completed: map['completed'] == 1,
      lessons: lessonList,
    );
  }

  @override
  String toString(){
    return 'id=$id, title=$title, folderName=$folderName, completed=$completed, lessons.length=${lessons.length}';
  }

  static void initTable(Database db){
    db.execute(
      '''CREATE TABLE ${LessonModule.tableName} (
          id INTEGER PRIMARY KEY,
          title TEXT,
          folder_name TEXT,
          completed INTEGER
        )'''
    );

    for(LessonModule lessonModule in LessonModule.covoiceLessonModulesInitializationList){
      db.insert(LessonModule.tableName, lessonModule.toMap());
    }
  }

  static Future<List<LessonModule>> findAll() async {
    Database db = await CovoiceDatabase.getInstance();
    List<Map<String, dynamic>> resultList = await db.query(LessonModule.tableName);
    return resultList.map((map) => LessonModule.fromMap(map)).toList();
  }

  static final List<LessonModule> covoiceLessonModulesInitializationList = [
    LessonModule(
      id: 1,
      title: 'Teoria 1: Os fundamentos',
      folderName: '/module_1',
    ),
    LessonModule(
      id: 2,
      title: 'Teoria 2: Harmonia', 
      folderName: '/module_2', 
    ),
  ];
}