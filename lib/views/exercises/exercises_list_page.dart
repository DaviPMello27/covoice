import 'package:covoice/entities/exercise.dart';
import 'package:covoice/views/exercises/exercise_page.dart';
import 'package:flutter/material.dart';

class ExercisesListPage  extends StatelessWidget {
  final String moduleName;
  final List<Exercise> exercises;
  const ExercisesListPage ({ required this.moduleName, required this.exercises, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercises'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: Iterable<int>.generate(exercises.length).toList().map(
            (i) => _ExerciseListTile(
              number: i+1,
              exercise: exercises[i],
            )
          ).toList(),
        ),
      ),
    );
  }
}

class _ExerciseListTile extends StatelessWidget {
  final int number;
  final Exercise exercise;

  const _ExerciseListTile({ required this.number, required this.exercise, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderSide verticalBorder = BorderSide(color: Theme.of(context).colorScheme.secondary, width: 0.5);

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        shape: Border(top: verticalBorder, bottom: verticalBorder),
        title: Text(
          '$number. ${exercise.title}',
          style: const TextStyle(
            fontSize: 18
          )
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...Iterable<int>.generate(5).map(
              (n) => Icon(
                Icons.star,
                color: (n+1) <= exercise.getNumStars() ? Colors.yellow : Theme.of(context).colorScheme.secondaryVariant
              )
            ),
            Icon(
              Icons.chevron_right, 
              color: Theme.of(context).colorScheme.secondary
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExercisePage(
                exercise: exercise,
                number: number
              ),
            ),
          );
        },
      ),
    );
  }
}