import 'package:covoice/controller/config_controller.dart';
import 'package:covoice/entities/exercise.dart';
import 'package:covoice/model/config_model.dart';
import 'package:covoice/views/exercises/exercises_list_page.dart';
import 'package:covoice/views/themes.dart';
import 'package:flutter/material.dart';

class ExerciseModulesListPage  extends StatefulWidget {
  const ExerciseModulesListPage ({ Key? key }) : super(key: key);

  @override
  State<ExerciseModulesListPage> createState() => _ExerciseModulesListPageState();
}

class _ExerciseModulesListPageState extends State<ExerciseModulesListPage> {
  bool loaded = false;
  Map<String, List<Exercise>>? modules;

  Future<Map<String, List<Exercise>>> loadModules() {
    return Exercise.findAllGroupByModule();
  }

  void loadModulesAndUpdateState(){
    setState(() {
      loaded = false;
    });
    loadModules().then(
      (result){
        setState(() {
          modules = result;
          loaded = true;
        });
      }
    );
  }

  void resetMaxScore() {
    setState(() {
      loaded = false;
    });
    Exercise.resetMaxScore().then((value){
      loadModulesAndUpdateState();
    });
  }

  @override
  void initState() {
    loadModulesAndUpdateState();
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
              resetMaxScore();
            }
          ),
        ],
      ),
      body: (loaded && modules != null) ? SingleChildScrollView(
        child: Column(
          children: modules!.entries.map(
            (entry) => _ExerciseModuleListTile(
              title: Exercise.translateModule(entry.key)[0].toUpperCase() + Exercise.translateModule(entry.key).substring(1),
              exercises: entry.value,
              onReturn: (){
                loadModulesAndUpdateState();
              }
            )
          ).toList(),
        ),
      ) : const Center(child: CircularProgressIndicator()),
    );
  }
}

class _ExerciseModuleListTile extends StatelessWidget {
  late final int maxStars;
  late final int currentStars;
  late final double completionRate;
  final String title;
  final List<Exercise> exercises;
  final bool inDevelopment;
  final void Function()? onReturn;

  _ExerciseModuleListTile({required this.title, required this.exercises, this.inDevelopment = false, this.onReturn, Key? key }) : super(key: key) {
    maxStars = exercises.length * 5;
    int starCounter = 0;
    for(Exercise exercise in exercises){
      starCounter += exercise.getNumStars();
    }
    currentStars = starCounter;
    completionRate = currentStars / maxStars;
  }

  @override
  Widget build(BuildContext context) {
    final BorderSide verticalBorder = BorderSide(
      color: inDevelopment ? Theme.of(context).colorScheme.secondaryVariant : Theme.of(context).colorScheme.secondary,
      width: 0.5
    );

    Color medalColor = CovoiceTheme.customColors.of(context).bronze;    
    
    if(completionRate == 1){
      medalColor = CovoiceTheme.customColors.of(context).platinum;
    } else if(completionRate >= 0.8){
      medalColor = CovoiceTheme.customColors.of(context).gold;
    } else if(completionRate >= 0.4){
      medalColor = CovoiceTheme.customColors.of(context).silver;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        shape: Border(top: verticalBorder, bottom: verticalBorder),
        trailing: Icon(
          Icons.chevron_right, 
          color: inDevelopment ? Theme.of(context).colorScheme.secondaryVariant : Theme.of(context).colorScheme.secondary,
        ),
        title: Text(
          title + (inDevelopment ? ' - Em desenvolvimento' : ''),
          style: const TextStyle(
            fontSize: 18
          )
        ),
        leading: inDevelopment ? 
          Icon(Icons.lock, color: Theme.of(context).colorScheme.secondaryVariant)
        : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: medalColor,
                border: Border.all(
                  width: 1, 
                  color: Theme.of(context).colorScheme.secondaryVariant
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '$currentStars/$maxStars', 
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        enabled: !inDevelopment,
        onTap: () async {
          await Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => ExercisesListPage(
                configController: ConfigController(ConfigModel()),
                moduleName: title, 
                exercises: exercises
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