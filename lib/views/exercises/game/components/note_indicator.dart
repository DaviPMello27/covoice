import 'package:covoice/views/exercises/game/exercise_game_state.dart';
import 'package:covoice/views/themes.dart';
import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class NoteIndicator extends RectangleComponent with HasGameRef {
  double duration;
  Vector2 pos;
  ExerciseGameState state;

  NoteIndicator({required this.pos, required this.duration, required this.state}) : super();
  
  @override
  Future<void>? onLoad() {
    add(
      RectangleComponent(
        position: pos,
        size: Vector2(duration, 20),
        paint: Paint()..color = Theme.of(state.context).colorScheme.secondary,
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

  static NoteIndicator fromNoteString(String string, ExerciseGameState state){
    List<String> noteList = ['A#4', 'A4', 'G#4', 'G4', 'F#4', 'F4', 'E4', 'D#4', 'D4', 'C#4', 'C4', 'B3', 'A#3', 'A3', 'G#3', 'G3', 'F#3'];

    String note = string.substring(0, string.indexOf('['));
    String start = string.substring(string.indexOf('[') + 1, string.indexOf('-'));
    String end = string.substring(string.indexOf('-') + 1, string.indexOf(']'));

    double targetLineXPosition = WidthProportion.of(state.context).full * 0.15;

    double positionX = (double.parse(start) / 10) + targetLineXPosition;
    double positionY = 35.0 + (30.0 * noteList.indexOf(note));
    double width = (double.parse(end) / 10) - (double.parse(start) / 10);
    

    return NoteIndicator(
        pos: Vector2(positionX, positionY),
        duration: width,
        state: state,
      );
  }
}