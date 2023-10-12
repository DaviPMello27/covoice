import 'package:covoice/entities/exercise.dart';
import 'package:covoice/entities/game_note.dart';
import 'package:covoice/entities/note.dart';
import 'package:flutter/material.dart';

class ExerciseGameState {
  Note note;
  BuildContext context;
  Exercise exercise;
  List<GameNote> notes;
  bool playing;
  bool recording;
  int timeElapsedInMilliseconds = 0;
  double score = 0;

  ExerciseGameState({
    required this.note, 
    required this.context, 
    required this.exercise,
    required this.notes, 
    required this.playing,
    required this.recording,
  });

  void reset(){
    playing = false;
    recording = false;
    score = 0;
    timeElapsedInMilliseconds = 0;
  }

  GameNote? getCurrentNote(){
    try {
      return notes.firstWhere((note) => note.start < timeElapsedInMilliseconds && timeElapsedInMilliseconds < note.end);
    } catch (error){
      return null;
    }
  }
}