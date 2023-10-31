import 'package:covoice/entities/lesson.dart';
import 'package:covoice/entities/lesson_module.dart';
import 'package:covoice/views/lerning/lesson_list_page.dart';
import 'package:flutter/material.dart';

class LessonModulesListPage extends StatefulWidget {
  const LessonModulesListPage({ Key? key }) : super(key: key);

  @override
  State<LessonModulesListPage> createState() => _LessonModulesListPageState();
}

class _LessonModulesListPageState extends State<LessonModulesListPage> {
  bool loaded = false;
  List<LessonModule>? modules;

  void markAllAsUnfinished() {
    setState(() {
      loaded = false;
    });
    Lesson.markAllAsUnfinished().then((_){
      loadLessonModules();
    });
  }

  void loadLessonModules(){
    LessonModule.findAll().then(
      (result){
        setState(() {
          loaded = true;
          modules = result;
        });
      }
    );
  }
  
  @override
  void initState() {
    loadLessonModules();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Módulos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: (){
              markAllAsUnfinished();
            }
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: loaded ? Column(
          children: modules!.map(
            (module) => _ModuleListTile(module: module, inDevelopment: [2].contains(module.id),)
          ).toList(),
        ) : const Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}

class _ModuleListTile extends StatelessWidget {
  final LessonModule module;
  final bool inDevelopment;

  const _ModuleListTile({ required this.module, this.inDevelopment = false, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderSide verticalBorder = BorderSide(
      width: 0.5,
      color: inDevelopment ? Theme.of(context).colorScheme.secondaryVariant : Theme.of(context).colorScheme.secondary,
    );

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        shape: Border(top: verticalBorder, bottom: verticalBorder),
        title: Text(
          '${module.id}. ${module.title}' + (inDevelopment ? ' - Em desenvolvimento' : ''),
          style: const TextStyle(
            fontSize: 18
          )
        ),
        trailing: Icon(
          Icons.chevron_right, 
          color: inDevelopment ? Theme.of(context).colorScheme.secondaryVariant : Theme.of(context).colorScheme.secondary,
        ),
        enabled: !inDevelopment,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonListPage(
                module: module,
              ),
            ),
          );
        },
      ),
    );
  }
}