import 'package:covoice/entities/lesson.dart';
import 'package:covoice/views/lerning/lesson_list_page.dart';
import 'package:flutter/material.dart';

class LearningModulesListPage extends StatelessWidget {
  const LearningModulesListPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Módulos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: Lesson.covoiceModules.map(
            (lesson) => _ModuleListTile(lesson: lesson)
          ).toList(),
        ),
      ),
    );
  }
}

class _ModuleListTile extends StatelessWidget {
  final Lesson lesson;

  const _ModuleListTile({ required this.lesson, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderSide verticalBorder = BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        shape: Border(top: verticalBorder, bottom: verticalBorder),
        title: Text(
          '${lesson.id}. ${lesson.title}',
          style: const TextStyle(
            fontSize: 18
          )
        ),
        trailing: Icon(
          Icons.chevron_right, 
          color: Theme.of(context).colorScheme.secondary
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonListPage(
                module: lesson,
              ),
            ),
          );
        },
      ),
    );
  }
}