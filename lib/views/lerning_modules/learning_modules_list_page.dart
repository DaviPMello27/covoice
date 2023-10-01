import 'package:covoice/views/lerning_modules/lesson_list_page.dart';
import 'package:flutter/material.dart';

class LearningModulesListPage extends StatelessWidget {
  final List<String> modules = const ['Theory 1: The fundamentals', 'Theory 2: Harmony'];
  const LearningModulesListPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: Iterable<int>.generate(modules.length).toList().map(
            (i) => _ModuleListTile(
              number: i+1,
              title: modules[i],
            )
          ).toList(),
        ),
      ),
    );
  }
}

class _ModuleListTile extends StatelessWidget {
  final int number;
  final String title;

  const _ModuleListTile({ required this.number, required this.title, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderSide verticalBorder = BorderSide(color: Theme.of(context).textTheme.subtitle1!.color!, width: 0.5);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        shape: Border(top: verticalBorder, bottom: verticalBorder),
        title: Text(
          '$number. $title',
          style: const TextStyle(
            fontSize: 18
          )
        ),
        trailing: Icon(
          Icons.chevron_right, 
          color: Theme.of(context).textTheme.subtitle1!.color!
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonListPage(
                module: title,
              ),
            ),
          );
        },
      ),
    );
  }
}