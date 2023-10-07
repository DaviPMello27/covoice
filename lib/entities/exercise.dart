class Exercise {
  late String _title;
  late int _stars;
  late String _folderName;
  late String _module;

  Exercise({required String title, required int stars, required String folderName, required String module}){
    _title = title;
    _stars = stars;
    _folderName = folderName;
    _module = module;
  }

  String get getTitle => _title;

  set setTitle(String title){
    _title = title;
  }

  int get getStars => _stars;

  set setStars(int stars){
    _stars = stars;
  }

  String get getFolderName => _folderName;

  set setFolderName(String folderName){
    _folderName = folderName;
  }

  String get getModule => _module;

  set setModule(String module){
    _module = module;
  }

  String get getFullPath => 'assets/exercises/$getModule$getFolderName';

  static final List<Exercise> covoiceExercises = [
    Exercise(
      stars: 5,
      title: 'Single note test: A',
      module: 'amateur',
      folderName: '/single_note_test_a',
    ),
    Exercise(
      stars: 5,
      title: 'Musical scale test: Scale of D',
      module: 'amateur',
      folderName: '/scale_of_g',
    ),
    Exercise(
      stars: 4,
      title: 'Simple melody test',
      module: 'amateur',
      folderName: '/simple_melody_test',
    ),

    Exercise(
      stars: 3,
      title: 'Happy Birthday to You',
      folderName: '',
      module: 'intermediary',
    ),
    Exercise(
      stars: 4,
      title: 'Jingle Bells',
      folderName: '',
      module: 'intermediary',
    ),
    Exercise(
      stars: 2,
      title: 'O Holy Night',
      folderName: '',
      module: 'intermediary',
    ),

    Exercise(
      stars: 2,
      title: 'Song 1',
      folderName: '',
      module: 'professional',
    ),
    Exercise(
      stars: 1,
      title: 'Song 2',
      folderName: '',
      module: 'professional',
    ),
    Exercise(
      stars: 1,
      title: 'Song 3',
      folderName: '',
      module: 'professional',
    ),
  ];
}