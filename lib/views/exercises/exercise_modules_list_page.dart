import 'package:covoice/entities/exercise.dart';
import 'package:covoice/views/exercises/exercises_list_page.dart';
import 'package:flutter/material.dart';

class ExerciseModulesListPage  extends StatelessWidget {
  const ExerciseModulesListPage ({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modules'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ExerciseModuleListTile(
              title: 'Amateur',
              exercises: Exercise.covoiceExercises.where((e) => e.module == 'amateur').toList()
            ),
            _ExerciseModuleListTile(
              title: 'Intermediary',
              exercises: Exercise.covoiceExercises.where((e) => e.module == 'intermediary').toList()
            ),
            _ExerciseModuleListTile(
              title: 'Professional',
              exercises: Exercise.covoiceExercises.where((e) => e.module == 'professional').toList()
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseModuleListTile extends StatelessWidget {
  late final int maxStars;
  late final int currentStars;
  late final double completionRate;
  final String title;
  final List<Exercise> exercises;

  _ExerciseModuleListTile({required this.title, required this.exercises, Key? key }) : super(key: key) {
    maxStars = exercises.length * 5;
    int starCounter = 0;
    for(Exercise exercise in exercises){
      starCounter += exercise.stars;
    }
    currentStars = starCounter;
    completionRate = currentStars / maxStars;
  }

  @override
  Widget build(BuildContext context) {
    final BorderSide verticalBorder = BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5);
    Color medalColor = Colors.brown;    
    
    if(completionRate == 1){
      medalColor = Colors.lightBlue;
    } else if(completionRate >= 0.8){
      medalColor = Colors.yellowAccent;
    } else if(completionRate >= 0.4){
      medalColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        shape: Border(top: verticalBorder, bottom: verticalBorder),
        trailing: Icon(
          Icons.chevron_right, 
          color: Theme.of(context).colorScheme.secondary,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18
          )
        ),
        leading: Row(
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
                  color: Theme.of(context).colorScheme.background
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
        onTap: (){
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => ExercisesListPage(
                moduleName: title, 
                exercises: exercises
              ),
            ),
          );
        },
      ),
    );
  }
}