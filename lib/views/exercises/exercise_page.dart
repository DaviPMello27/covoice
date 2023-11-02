import 'dart:convert';

import 'package:covoice/controller/config_controller.dart';
import 'package:covoice/controller/config_controller_inteface.dart';
import 'package:covoice/controller/recording_controller.dart';
import 'package:covoice/entities/exercise.dart';
import 'package:covoice/entities/game_note.dart';
import 'package:covoice/entities/note.dart';
import 'package:covoice/model/config_model.dart';
import 'package:covoice/model/recording_model.dart';
import 'package:covoice/views/exercises/exercise_results_page.dart';
import 'package:covoice/views/exercises/exercises_list_page.dart';
import 'package:covoice/views/exercises/game/exercise_game.dart';
import 'package:covoice/views/exercises/game/exercise_game_state.dart';
import 'package:covoice/views/exercises/tutorial_page.dart';
import 'package:covoice/views/themes.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExercisePage extends StatefulWidget {
  final int number;
  final Exercise exercise;

  const ExercisePage({ required this.exercise, required this.number, Key? key }) : super(key: key);

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  bool loaded = false;
  late ExerciseGameState state;

  final RecordingController recordingController = RecordingController(RecordingModel());

  Future loadExerciseNoteStrings() async {
    String exercisePath = widget.exercise.getFullPath;
    String fileString = await rootBundle.loadString('$exercisePath/notes');

    setState(() {
      state = ExerciseGameState(
        context: context,
        exercise: widget.exercise,
        sangNote: Note(time: 0, frequency: double.infinity),
        notes: LineSplitter.split(fileString).toList().where((text) => text.isNotEmpty).map((string) => GameNote.fromString(string)).toList(),
        playing: false,
        recording: false,
      );
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
        title: const Text('Exercício'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => TutorialPage(
                  configController: ConfigController(ConfigModel()),
                  onFinish: (){
                    Navigator.of(context).pop();
                  },
                  displayCheckbox: false,
                ))
              );
            }
          )
        ],
      ),
      body: loaded ? Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Text(
              'Exercício ${widget.number}',
              style: Theme.of(context).textTheme.headline3,
            ),
            SizedBox(
              width: WidthProportion.of(context).half,
              child: Divider(color: Theme.of(context).colorScheme.secondary),
            ),
            Text(
              widget.exercise.title,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ClipRect(
                  child: GameWidget(
                    game: ExerciseGame(
                      state: state,
                      onEndPlaying: (){
                        setState(() {
                          state.sangNote.frequency = double.infinity;
                          state.playing = false;
                          state.recording = false;
                        });
                      },
                      onEndRecording: (){
                        recordingController.stopRecordingStreamWithoutStoring();
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => ExerciseResultsPage(state: state, number: widget.number))
                        );
                        setState(() {
                          state.sangNote.frequency = double.infinity;
                          state.playing = false;
                          state.recording = false;
                        });
                      }
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
                      if(!state.playing){
                        if(!state.recording){
                          recordingController.startRecordingStreamWithoutStoring(
                            (frequency){
                              if(frequency != -1.0 && frequency > 100 && frequency < 800){
                                state.sangNote.frequency = frequency;
                              }
                            },
                          );
                        } else {
                          setState(() {
                            state.score = 0;
                            state.sangNote.frequency = double.infinity;
                          });
                          recordingController.stopRecordingStreamWithoutStoring();
                        }

                        setState(() {
                          state.recording = !state.recording;
                        });
                      }
                    },
                    icon: Icon(
                      state.recording ? Icons.stop : Icons.mic,
                      color: Theme.of(context).colorScheme.secondary
                    )
                  ),
                ),
                Transform.scale(
                  scale: 2,
                  child: IconButton(
                    onPressed: (){
                      if(!state.recording){
                        setState(() {
                          state.sangNote.frequency = double.infinity;
                          state.playing = !state.playing;
                        });
                      }
                    },
                    icon: Icon(
                      !state.playing ? Icons.play_arrow : Icons.pause,
                      color: Theme.of(context).colorScheme.secondary
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

  @override
  void dispose() {
    recordingController.stopRecordingStreamWithoutStoring();
    if(FlameAudio.bgm.isPlaying){
      FlameAudio.bgm.stop();
    }
    super.dispose();
  }
}