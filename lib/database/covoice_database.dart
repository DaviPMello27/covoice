import 'package:covoice/entities/exercise.dart';
import 'package:covoice/entities/lesson.dart';
import 'package:covoice/entities/lesson_module.dart';
import 'package:sqflite/sqflite.dart';

class CovoiceDatabase {
  static Database? _instance;

  static final List<String> _migrationScripts = [];

  static Future<Database> getInstance() async {
    if(_instance == null){
      await initDatabase();
    }
    return _instance!;
  }

  static Future<Database> initDatabase() async {
    _instance = await openDatabase(
      '${await getDatabasesPath()}/covoice_database.db',
      onCreate:(db, version) {
        Exercise.initTable(db);
        LessonModule.initTable(db);
        Lesson.initTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        for (var i = oldVersion - 1; i <= newVersion - 1; i++) {
          await db.execute(_migrationScripts[i]);
        }  
      },
      version: 1,
    );
    return _instance!;
  }
}
