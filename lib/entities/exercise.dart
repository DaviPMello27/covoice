class Exercise {
  late String title;
  late int stars;
  late int maxScore;
  late String folderName;
  late String module;

  Exercise({required this.title, required this.stars, required this.folderName, required this.maxScore, required this.module});

  String get getFullPath => 'assets/exercises/$module$folderName';

  static final List<Exercise> covoiceExercises = [
    Exercise(
      stars: 5,
      title: 'Single note test: A',
      module: 'amateur',
      folderName: '/single_note_test_a',
      maxScore: 250,
    ),
    Exercise(
      stars: 5,
      title: 'Musical scale test: Scale of G',
      module: 'amateur',
      folderName: '/scale_of_g',
      maxScore: 640,
    ),
    Exercise(
      stars: 4,
      title: 'Simple melody test',
      module: 'amateur',
      folderName: '/simple_melody_test',
      maxScore: 0,
    ),

    Exercise(
      stars: 3,
      title: 'Happy Birthday to You',
      module: 'intermediary',
      folderName: '',
      maxScore: 0,
    ),
    Exercise(
      stars: 4,
      title: 'Jingle Bells',
      module: 'intermediary',
      folderName: '',
      maxScore: 0,
    ),
    Exercise(
      stars: 2,
      title: 'O Holy Night',
      module: 'intermediary',
      folderName: '',
      maxScore: 0,
    ),

    Exercise(
      stars: 2,
      title: 'Song 1',
      module: 'professional',
      folderName: '',
      maxScore: 0,
    ),
    Exercise(
      stars: 1,
      title: 'Song 2',
      module: 'professional',
      folderName: '',
      maxScore: 0,
    ),
    Exercise(
      stars: 1,
      title: 'Song 3',
      module: 'professional',
      folderName: '',
      maxScore: 0,
    ),
  ];
}