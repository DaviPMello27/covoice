import 'package:covoice/entities/lesson.dart';
import 'package:covoice/entities/lesson_module.dart';
import 'package:covoice/views/lerning/lesson_page.dart';
import 'package:flutter/material.dart';

class LessonListPage extends StatefulWidget {
  final LessonModule module;

  const LessonListPage({required this.module, Key? key }) : super(key: key);

  @override
  State<LessonListPage> createState() => _LessonListPageState();
}

class _LessonListPageState extends State<LessonListPage> {
  bool loaded = false;
  List<Lesson>? lessons;

  void loadLessons(){
    setState(() {
      loaded = false;
    });
    Lesson.findAllByLessonModule(widget.module).then((result){
      setState(() {
        loaded = true;
        lessons = result;
      });
    });
  }

  @override
  void initState() {
    loadLessons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lições'),
      ),
      body: SingleChildScrollView(
        child: loaded ? Column(
          children: lessons!
            .map(
              (lesson) => _LessonListTile(
                module: widget.module,
                lesson: lesson,
                onReturn: loadLessons,
              )
            ).toList(),
        ) : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class _LessonListTile extends StatelessWidget {
  final LessonModule module;
  final Lesson lesson;
  final void Function()? onReturn;

  const _LessonListTile({ required this.module, required this.lesson, this.onReturn, Key? key }) : super(key: key);

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
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonPage(
                module: module,
                lesson: lesson,
              ),
            ),
          );
          if(onReturn != null){
            onReturn!();
          }
        },
      ),
    );
  }
}