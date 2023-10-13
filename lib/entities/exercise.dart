import 'package:covoice/database/covoice_database.dart';

class Exercise {
  static double maxScoreTolerance = 0.1;

  int? id;
  late String title;
  late int maxScore;
  late int maxPossibleScore;
  late String folderName;
  late String module;

  Exercise({required this.title, required this.maxScore, required this.folderName, required this.maxPossibleScore, required this.module});

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

  Future<Exercise> save() async {
    id = await (await CovoiceDatabase.getInstance()).insert('exercise', toMap());
    return this;
  }

  int getNumStars(){
    return (5*maxScore / (maxPossibleScore * (1-Exercise.maxScoreTolerance))).floor();
  }

  String get getFullPath => 'assets/exercises/$module$folderName';

  static final List<Exercise> covoiceExercises = [
    Exercise(
      maxScore: 5,
      title: 'Single note test: A',
      module: 'amateur',
      folderName: '/single_note_test_a',
      maxPossibleScore: 250,
    ),
    Exercise(
      maxScore: 5,
      title: 'Simple melody test',
      module: 'amateur',
      folderName: '/simple_melody_test',
      maxPossibleScore: 600,
    ),
    Exercise(
      maxScore: 4,
      title: 'Musical scale test: Scale of G',
      module: 'amateur',
      folderName: '/scale_of_g',
      maxPossibleScore: 640,
    ),

    Exercise(
      maxScore: 3,
      title: 'Happy Birthday to You',
      module: 'intermediary',
      folderName: '',
      maxPossibleScore: 0,
    ),
    Exercise(
      maxScore: 4,
      title: 'Jingle Bells',
      module: 'intermediary',
      folderName: '',
      maxPossibleScore: 0,
    ),
    Exercise(
      maxScore: 2,
      title: 'O Holy Night',
      module: 'intermediary',
      folderName: '',
      maxPossibleScore: 0,
    ),

    Exercise(
      maxScore: 2,
      title: 'Song 1',
      module: 'professional',
      folderName: '',
      maxPossibleScore: 0,
    ),
    Exercise(
      maxScore: 1,
      title: 'Song 2',
      module: 'professional',
      folderName: '',
      maxPossibleScore: 0,
    ),
    Exercise(
      maxScore: 1,
      title: 'Song 3',
      module: 'professional',
      folderName: '',
      maxPossibleScore: 0,
    ),
  ];
}