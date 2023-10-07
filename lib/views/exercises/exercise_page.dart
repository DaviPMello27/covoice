import 'dart:convert';

import 'package:covoice/controller/recording_controller.dart';
import 'package:covoice/entities/exercise.dart';
import 'package:covoice/entities/note.dart';
import 'package:covoice/model/recording_model.dart';
import 'package:covoice/views/exercises/exercises_list_page.dart';
import 'package:covoice/views/exercises/game/exercise_game.dart';
import 'package:covoice/views/exercises/game/exercise_game_state.dart';
import 'package:covoice/views/themes.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExercisePage extends StatefulWidget {
  final int number;
  final Exercise exercise;

  const ExercisePage ({ required this.exercise, required this.number, Key? key }) : super(key: key);

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  Note sangNote = Note(time: 0);
  bool loaded = false;
  bool recording = false;
  bool playing = false;
  List<String> noteStrings = []; //TODO: Convert right here to a note of some kind and stop working with strings

  final RecordingController recordingController = RecordingController(RecordingModel());

  Future loadExerciseNoteStrings() async {
    String exercisePath = widget.exercise.getFullPath;
    String fileString = await rootBundle.loadString('$exercisePath/notes');
    noteStrings = LineSplitter.split(fileString).toList();
    
    setState(() {
      loaded = true;
    });
  }

  @override
  void initState() {
    loadExerciseNoteStrings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise'),
      ),
      body: loaded ? Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(
              'Exercise ${widget.number}',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              width: WidthProportion.of(context).half,
              child: const Divider(color: Color.fromARGB(255, 178, 215, 232)),
            ),
            Text(
              widget.exercise.getTitle,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ClipRect(
                  child: GameWidget(
                    game: ExerciseGame(
                      state: ExerciseGameState(
                        note: sangNote,
                        exercise: widget.exercise,
                        context: context,
                        noteStrings: noteStrings,
                        playing: playing,
                        recording: recording,
                      )
                    )
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Transform.scale(
                  scale: 2,
                  child: IconButton(
                    onPressed: (){
                      if(!recording){
                        recordingController.startRecordingStream(
                          (frequency){
                            if(frequency != -1.0 && frequency > 100 && frequency < 800){
                              sangNote.frequency = frequency;
                            }
                          },
                          (amp){
                            /* log("Amp $amp"); */
                          }
                        );
                      } else {
                        recordingController.stopRecordingStream();
                      }

                      setState(() {
                        recording = !recording;
                      });
                    },
                    icon: Icon(
                      recording ? Icons.stop : Icons.mic,
                      color: const Color.fromARGB(255, 178, 215, 232),
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
      ) : const Center(child: CircularProgressIndicator(),)
    );
  }
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
    final BorderSide verticalBorder = BorderSide(color: Theme.of(context).colorScheme.secondaryVariant, width: 0.5);
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
          color: Theme.of(context).colorScheme.secondaryVariant,
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