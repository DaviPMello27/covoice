import 'package:covoice/entities/game_note.dart';
import 'package:covoice/views/exercises/game/components/boundary.dart';
import 'package:covoice/views/exercises/game/exercise_game_state.dart';
import 'package:covoice/views/themes.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class NoteIndicator extends RectangleComponent with HasGameRef {
  double duration;
  Vector2 pos;
  ExerciseGameState state;
  bool counts;

  NoteIndicator({required this.pos, required this.duration, required this.state, required this.counts}) : super();
  
  @override
  Future<void>? onLoad() {
    add(
      RectangleComponent(
        position: pos,
        size: Vector2(duration, Boundary.noteLabelHeight - 10),
        paint: Paint()..color = counts ? Theme.of(state.context).colorScheme.secondary : Theme.of(state.context).colorScheme.secondaryVariant.withAlpha(64),
      )
    );
    return super.onLoad();
  }

  @override
  void update(double dt) {
    FlameAudio.bgm.audioPlayer?.getCurrentPosition().then((duration) {
      position.x =- duration.toDouble() / 10; // divide by 10 because duration is in miliseconds, and one second = 100 pixels
    });
    super.update(dt);
  }

  static NoteIndicator fromGameNote(GameNote note, ExerciseGameState state){
    double targetLineXPosition = WidthProportion.of(state.context).full * 0.15;

    Vector2 transformedPosition = Vector2( 
      (note.start / 10) + targetLineXPosition,
      (Boundary.noteLabelHeight + 5) + (Boundary.noteLabelHeight * state.displayedNotes.indexOf(note.note)),
    );

    double width = (note.end / 10) - (note.start / 10);
    
    return NoteIndicator(pos: transformedPosition, duration: width, state: state, counts: note.counts);
  }
}