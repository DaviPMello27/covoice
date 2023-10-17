class Lesson {
  int id;
  bool isModule;
  String title;
  String folderName;
  bool completed;
  List<Lesson> childLessons;

  Lesson({required this.id, required this.title, required this.folderName, this.isModule = false, this.childLessons = const [], this.completed = false});

  static final List<Lesson> covoiceModules = [
    Lesson(
      id: 1,
      title: 'Teoria 1: Os fundamentos',
      folderName: '/module_1',
      isModule: true,
      childLessons: [
        Lesson(
          id: 1,
          title: 'Introdução à música',
          folderName: '/introduction_to_music',
          completed: true,
        ),
        Lesson(
          id: 2,
          title: 'Notas',
          folderName: '/notes',
          completed: true,
        ),
        Lesson(
          id: 3,
          title: 'Altura',
          folderName: '/pitch',
        ),
        Lesson(
          id: 4,
          title: 'Frequência',
          folderName: '/frequency',
        ),
      ]
    ),
    Lesson(
      id: 2, 
      title: 'Teoria 2: Harmonia', 
      folderName: '/module_2', 
      isModule: true,
      childLessons: [
        Lesson(
          id: 1,
          title: 'Introdução aos intervalos',
          folderName: '/introduction_to_intervals',
        ),
        Lesson(
          id: 2,
          title: 'Acordes',
          folderName: '/chords',
        ),
        Lesson(
          id: 3,
          title: 'Harmonia vocal: o básico',
          folderName: '/vocal_harmony_the_basics',
        ),
        Lesson(
          id: 4,
          title: 'Harmonia vocal: avançado',
          folderName: '/vocal_harmony_advanced',
        ),
      ]
    ),
  ];
}

/*

final List<_Lesson> lessonsFromModule1 = [
  _Lesson(completed: true, title: 'Introduction to music'),
  _Lesson(completed: true, title: 'Notes'),
  _Lesson(completed: false, title: 'Pitch'),
  _Lesson(completed: false, title: 'Frequency'),
];

final List<_Lesson> lessonsFromModule2 = [
  _Lesson(completed: false, title: 'Introduction to intervals'),
  _Lesson(completed: false, title: 'Chords'),
  _Lesson(completed: false, title: 'Vocal harmony: The basics'),
  _Lesson(completed: false, title: 'Vocal harmony: Advanced'),
];

*/