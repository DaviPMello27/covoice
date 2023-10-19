import 'package:covoice/entities/exercise.dart';
import 'package:covoice/views/exercises/exercise_page.dart';
import 'package:covoice/views/themes.dart';
import 'package:flutter/material.dart';

class ExercisesListPage  extends StatefulWidget {
  final String moduleName;
  final List<Exercise> exercises;
  const ExercisesListPage ({ required this.moduleName, required this.exercises, Key? key }) : super(key: key);

  @override
  State<ExercisesListPage> createState() => _ExercisesListPageState();
}

class _ExercisesListPageState extends State<ExercisesListPage> {
  bool loaded = false;
  List<Exercise> exercises = [];
  
  Future updateExercises() async {
    Exercise.findAllByModule(widget.moduleName).then(
      (result) {
        setState(() {
          exercises = result;
          loaded = true;
        });
      }
    );
  }
  
  @override
  void initState() {
    setState(() {
      exercises = widget.exercises;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercícios'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: Iterable<int>.generate(widget.exercises.length).toList().map(
            (i) => _ExerciseListTile(
              number: i+1,
              exercise: widget.exercises[i],
              onReturn: (){
                setState(() {
                  loaded = false;
                });
                updateExercises();
              }
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
  final void Function()? onReturn;

  const _ExerciseListTile({ required this.number, required this.exercise, this.onReturn, Key? key }) : super(key: key);

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
              (n) => _Star(color: (n+1) <= exercise.getNumStars() ? CovoiceTheme.customColors.of(context).gold : Theme.of(context).colorScheme.secondaryVariant)
            ),
            Icon(
              Icons.chevron_right, 
              color: Theme.of(context).colorScheme.secondary
            ),
          ],
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExercisePage(
                exercise: exercise,
                number: number
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

class _Star extends StatelessWidget {
  Color color;
  _Star({ required this.color, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Transform mainStar = Transform.scale(
      scale: 0.6, 
      child: Icon(
        Icons.star,
        color: color,
      ),
    );

    Icon borderStar = Icon(
      Icons.star,
      color: Theme.of(context).colorScheme.secondaryVariant,
    );


    return Stack(
      alignment: Alignment.center,
      children: [
        borderStar,
        mainStar,
      ],
    );
  }
}