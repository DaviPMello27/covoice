import 'package:covoice/database/covoice_database.dart';
import 'package:covoice/entities/lesson_module.dart';
import 'package:sqflite/sqlite_api.dart';

//TODO: Entity annotation
class Lesson {
  static const String tableName = 'lesson';
  
  int? id;
  String title;
  String folderName;
  bool completed;
  int? lessonModuleId;
  LessonModule? module;

  Lesson({this.id, required this.title, required this.folderName, this.completed = false, this.lessonModuleId});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'folder_name': folderName,
      'completed': completed ? 1 : 0,
      'lesson_module_id': lessonModuleId,
    };
  }

  static Lesson fromMap(Map<String, dynamic> map){
    return Lesson(
      id: map['id'], 
      title: map['title'], 
      folderName: map['folder_name'], 
      completed: map['completed'] == 1, 
      lessonModuleId: map['lesson_module_id'], 
    );
  }

  @override
  String toString(){
    return 'id=$id, title=$title, folderName=$folderName, completed=$completed, lessonModuleId=$lessonModuleId';
  }

  static void initTable(Database db){
    db.execute(
      '''CREATE TABLE ${Lesson.tableName} (
        id INTEGER PRIMARY KEY,
        title TEXT,
        folder_name TEXT,
        completed INTEGER,
        lesson_module_id INTEGER,
        FOREIGN KEY(lesson_module_id) REFERENCES ${LessonModule.tableName}(id)
      )'''
    );

    for(Lesson lesson in Lesson.covoiceLessonInitializationList){
      db.insert(Lesson.tableName, lesson.toMap());
    }
  }

  static Future<List<Lesson>> findAllByLessonModule(LessonModule lessonModule) async {
    Database db = await CovoiceDatabase.getInstance();
    List<Map<String, dynamic>> resultList = await db.query(Lesson.tableName, where: 'lesson_module_id = ?', whereArgs: [lessonModule.id]);
    return resultList.map((map) => Lesson.fromMap(map)).toList();
  }

  Future<void> markAsFinished() async {
    Database db = await CovoiceDatabase.getInstance();
    completed = true;
    await db.insert(Lesson.tableName, toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> markAllAsUnfinished() async {
    Database db = await CovoiceDatabase.getInstance();
    await db.update(Lesson.tableName, {'completed': 0});
  }

  static final List<Lesson> covoiceLessonInitializationList = [
    Lesson(
      title: 'Introdução à música',
      folderName: '/introduction_to_music',
      lessonModuleId: 1,
    ),
    Lesson(
      title: 'Notas',
      folderName: '/notes',
      lessonModuleId: 1,
    ),
    Lesson(
      title: 'Altura',
      folderName: '/pitch',
      lessonModuleId: 1,
    ),
    Lesson(
      title: 'Frequência',
      folderName: '/frequency',
      lessonModuleId: 1,
    ),
    Lesson(
      title: 'Introdução aos intervalos',
      folderName: '/introduction_to_intervals',
      lessonModuleId: 2,
    ),
    Lesson(
      title: 'Acordes',
      folderName: '/chords',
      lessonModuleId: 2,
    ),
    Lesson(
      title: 'Harmonia vocal: o básico',
      folderName: '/vocal_harmony_the_basics',
      lessonModuleId: 2,
    ),
    Lesson(
      title: 'Harmonia vocal: avançado',
      folderName: '/vocal_harmony_advanced',
      lessonModuleId: 2,
    ),
  ];
}