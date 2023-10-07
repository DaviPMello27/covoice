import 'package:covoice/entities/exercise.dart';
import 'package:covoice/entities/note.dart';
import 'package:flutter/material.dart';

class ExerciseGameState {
  Note note;
  BuildContext context;
  Exercise exercise;
  List<String> noteStrings;
  bool playing;
  bool recording;
  double timeElapsed = 0.0;
  int score = 0;

  ExerciseGameState({
    required this.note, 
    required this.context, 
    required this.exercise,
    required this.noteStrings, 
    required this.playing,
    required this.recording,
  });
}