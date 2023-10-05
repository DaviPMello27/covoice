import 'package:covoice/entities/lesson.dart';
import 'package:covoice/views/lerning/lesson_page.dart';
import 'package:flutter/material.dart';

class LessonListPage extends StatelessWidget {
  final Lesson module;

  const LessonListPage({required this.module, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: module.childLessons
            .map(
              (lesson) => _LessonListTile(
                module: module,
                lesson: lesson,
              )
            ).toList(),
        ),
      ),
    );
  }
}

class _LessonListTile extends StatelessWidget {
  final Lesson module;
  final Lesson lesson;

  const _LessonListTile({ required this.module, required this.lesson, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderSide verticalBorder = BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        shape: Border(top: verticalBorder, bottom: verticalBorder),
        title: Text(
          lesson.title,
          style: const TextStyle(
            fontSize: 18
          )
        ),
        leading: Icon(
          Icons.check_circle,
          color: lesson.completed ? Colors.green.shade300 : Theme.of(context).colorScheme.secondaryVariant,
        ),
        trailing: Icon(
          Icons.chevron_right, 
          color: Theme.of(context).colorScheme.secondary
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonPage(
                module: module,
                lesson: lesson,
              ),
            ),
          );
        },
      ),
    );
  }
}