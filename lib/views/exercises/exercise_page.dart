import 'package:covoice/entities/exercise.dart';
import 'package:covoice/views/exercises/exercises_list_page.dart';
import 'package:covoice/views/themes.dart';
import 'package:flutter/material.dart';

class ExercisePage  extends StatelessWidget {
  final int number;
  final Exercise exercise;

  const ExercisePage ({ required this.exercise, required this.number, Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text('Exercise $number', style: Theme.of(context).textTheme.headline3,),
            SizedBox(
              width: WidthProportion.of(context).half,
              child: const Divider(color: Color.fromARGB(255, 178, 215, 232)),
            ),
            Text(exercise.getTitle, style: Theme.of(context).textTheme.subtitle1!.copyWith(color: const Color.fromARGB(255, 178, 215, 232)),),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(color: Colors.red,),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 2,
                  child: IconButton(
                    onPressed: (){},
                    icon: const Icon(
                      Icons.mic,
                      color: Color.fromARGB(255, 178, 215, 232),
                    )
                  ),
                ),
                Transform.scale(
                  scale: 2,
                  child: IconButton(
                    onPressed: (){},
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Color.fromARGB(255, 178, 215, 232),
                    )
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }

  /*
  Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text('Exercise $number', style: Theme.of(context).textTheme.headline3,),
          SizedBox(
            width: WidthProportion.of(context).half,
            child: const Divider(color: Color.fromARGB(255, 178, 215, 232)),
          ),
          Text(exercise.getTitle, style: Theme.of(context).textTheme.subtitle1!.copyWith(color: const Color.fromARGB(255, 178, 215, 232)),),
          //SizedBox.expand(child: Container(color: Colors.red)),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.scale(
                  scale: 2,
                  child: IconButton(
                    onPressed: (){},
                    icon: const Icon(
                      Icons.mic,
                      color: Color.fromARGB(255, 178, 215, 232),
                    )
                  ),
                ),
                Transform.scale(
                  scale: 2,
                  child: IconButton(
                    onPressed: (){},
                    icon: const Icon(
                      Icons.play_arrow,
                      color: Color.fromARGB(255, 178, 215, 232),
                    )
                  ),
                ),
              ],
            ),
          )
        ],
      ),
  */
}

class _ExerciseModuleListTile extends StatelessWidget {
  late int maxStars;
  late int currentStars;
  late double completionRate;
  final String title;
  final List<Exercise> exercises;

  _ExerciseModuleListTile({required this.title, required this.exercises, Key? key }) : super(key: key) {
    maxStars = exercises.length * 5;
    int starCounter = 0;
    for(Exercise exercise in exercises){
      starCounter += exercise.getStars;
    }
    currentStars = starCounter;
    completionRate = currentStars / maxStars;
  }

  @override
  Widget build(BuildContext context) {
    final BorderSide verticalBorder = BorderSide(color: Theme.of(context).textTheme.subtitle1!.color!, width: 0.5);
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
          color: Theme.of(context).textTheme.subtitle1!.color!
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
                  color: Colors.blueGrey.shade900
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