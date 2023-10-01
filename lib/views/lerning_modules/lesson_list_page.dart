import 'package:flutter/material.dart';

class _Lesson { //TODO: External
  bool completed;
  String title;

  _Lesson({required this.completed, required this.title});
}

class LessonListPage extends StatelessWidget {
  final String module;

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

  LessonListPage({required this.module, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: (module == 'Theory 1: The fundamentals' ? lessonsFromModule1 : lessonsFromModule2)
            .map(
              (lesson) => _LessonListTile(
                completed: lesson.completed,
                title: lesson.title,
              )
            ).toList(),
        ),
      ),
    );
  }
}

class _LessonListTile extends StatelessWidget {
  final bool completed;
  final String title;

  const _LessonListTile({ required this.completed, required this.title, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderSide verticalBorder = BorderSide(color: Theme.of(context).textTheme.subtitle1!.color!, width: 0.5);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        shape: Border(top: verticalBorder, bottom: verticalBorder),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18
          )
        ),
        leading: Icon(
          Icons.check_circle,
          color: completed ? Colors.green.shade300 : Theme.of(context).colorScheme.secondaryVariant,
        ),
        trailing: Icon(
          Icons.chevron_right, 
          color: Theme.of(context).textTheme.subtitle1!.color!
        ),
        onTap: () {
          /* Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExercisePage(
                exercise: exercise,
                number: number
              ),
            ),
          ); */
        },
      ),
    );
  }
}