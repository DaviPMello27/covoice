import 'package:covoice/entities/exercise.dart';
import 'package:covoice/entities/game_note.dart';
import 'package:covoice/entities/note.dart';
import 'package:flutter/material.dart';

class ExerciseGameState {
  Note sangNote;
  BuildContext context;
  Exercise exercise;
  List<GameNote> notes;
  List<String> displayedNotes = [];
  bool playing;
  bool recording;
  int timeElapsedInMilliseconds = 0;
  double score = 0;

  ExerciseGameState({
    required this.sangNote, 
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

  GameNote? getCurrentCountingNote(){
    try {
      return notes.firstWhere((note) => note.counts && note.start < timeElapsedInMilliseconds && timeElapsedInMilliseconds < note.end);
    } catch (error){
      return null;
    }
  }
}