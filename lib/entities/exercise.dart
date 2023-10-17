import 'package:covoice/database/covoice_database.dart';
import 'package:sqflite/sqlite_api.dart';

class Exercise {
  static double maxScoreTolerance = 0.1;

  int? id;
  late String title;
  late int maxScore;
  late int maxPossibleScore;
  late String folderName;
  late String module;

  Exercise({required this.title, required this.maxScore, required this.folderName, required this.maxPossibleScore, required this.module, this.id});

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'title': title,
      'maxScore': maxScore,
      'maxPossibleScore': maxPossibleScore,
      'folderName': folderName,
      'module': module,
    };
  }

  static Exercise fromMap(Map<String, dynamic> map){
    return Exercise(
      title: map['title'], 
      maxScore: map['maxScore'], 
      folderName: map['folderName'], 
      maxPossibleScore: map['maxPossibleScore'], 
      module: map['module'], 
      id: map['id']
    );
  }

  @override
  String toString(){
    return 'id=$id, title=$title, maxScore=$maxScore, maxPossibleScore=$maxPossibleScore, folderName=$folderName, module=$module';
  }

  int getNumStars(){
    return (5*maxScore / (maxPossibleScore * (1-Exercise.maxScoreTolerance))).floor();
  }

  String get getFullPath => 'assets/exercises/$module$folderName';

  //TODO: Place database operations elsewhere
  static Future<List<Exercise>> findByModule(String module) async {
    Database db = await CovoiceDatabase.getInstance();
    List<Map<String, dynamic>> databaseResult = await db.query('exercise', where: 'module = ?', whereArgs: [module]);
    return databaseResult.map((map) => Exercise.fromMap(map)).toList();
  }

  static Future<Map<String, List<Exercise>>> findAllGroupByModule() async {
    Map<String, List<Exercise>> groupedExercises = <String, List<Exercise>>{};
    Database db = await CovoiceDatabase.getInstance();
    List<Map<String, dynamic>> databaseResult = await db.query('exercise');
    for(Map<String, dynamic> result in databaseResult){
      Exercise exercise = Exercise.fromMap(result);
      if(groupedExercises.containsKey(exercise.module)){
        groupedExercises[exercise.module]!.add(exercise);
      } else {
        groupedExercises.addAll({exercise.module: [exercise]});
      }
    }
    return groupedExercises;
  }

  static Future<Exercise> save(Exercise exercise) async {
    print('Saving ${exercise.toString()}');
    Database db = await CovoiceDatabase.getInstance();
    int insertedId = await db.insert('exercise', exercise.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    exercise.id = insertedId;
    print('Saved ${exercise.toString()}');
    return exercise;
  }

  static Future resetMaxScore() async {
    Database db = await CovoiceDatabase.getInstance();
    db.update('exercise', {'maxScore': 0});
  }

  //TODO: Internationalization
  static String translateModule(String moduleName){
    switch(moduleName){
      case 'amateur':
        return 'amador';
      case 'intermediary':
        return 'intermediário';
      case 'professional':
        return 'profissional';
      default:
        return 'null';
    }
  }

  static final List<Exercise> covoiceExerciseInitializationList = [
    Exercise(
      maxScore: 0,
      title: 'Teste de uma nota: A',
      module: 'amateur',
      folderName: '/single_note_test_a',
      maxPossibleScore: 250,
    ),
    Exercise(
      maxScore: 0,
      title: 'Teste de melodia simples',
      module: 'amateur',
      folderName: '/simple_melody_test',
      maxPossibleScore: 600,
    ),
    Exercise(
      maxScore: 0,
      title: 'Teste de escala musical: Escala de G',
      module: 'amateur',
      folderName: '/scale_of_g',
      maxPossibleScore: 640,
    ),

    Exercise(
      maxScore: 0,
      title: 'Happy Birthday to You',
      module: 'intermediary',
      folderName: '',
      maxPossibleScore: 999,
    ),
    Exercise(
      maxScore: 0,
      title: 'Jingle Bells',
      module: 'intermediary',
      folderName: '',
      maxPossibleScore: 999,
    ),
    Exercise(
      maxScore: 0,
      title: 'O Holy Night',
      module: 'intermediary',
      folderName: '',
      maxPossibleScore: 999,
    ),

    Exercise(
      maxScore: 0,
      title: 'Song 1',
      module: 'professional',
      folderName: '',
      maxPossibleScore: 999,
    ),
    Exercise(
      maxScore: 0,
      title: 'Song 2',
      module: 'professional',
      folderName: '',
      maxPossibleScore: 999,
    ),
    Exercise(
      maxScore: 0,
      title: 'Song 3',
      module: 'professional',
      folderName: '',
      maxPossibleScore: 999,
    ),
  ];
}