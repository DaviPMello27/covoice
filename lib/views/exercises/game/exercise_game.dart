import 'package:covoice/views/exercises/game/components/boundary.dart';
import 'package:covoice/views/exercises/game/components/note_indicator.dart';
import 'package:covoice/views/exercises/game/components/target_line.dart';
import 'package:covoice/views/exercises/game/components/voice_indicator.dart';
import 'package:covoice/views/exercises/game/exercise_game_state.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class ExerciseGame extends FlameGame {
  ExerciseGameState state;

  ExerciseGame({required this.state}) : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if(state.playing || state.recording){ //TODO: Audio
      FlameAudio.audioCache.prefix = '';
      FlameAudio.playLongAudio('${state.exercise.getFullPath}/audio.mp3');
    }

    add(
      RectangleComponent(
        position: Vector2(0, 0),
        size: Vector2(size.x, size.y),
        paint: Paint()..color = Theme.of(state.context).colorScheme.surface
      )
    );

    add(TargetLine(context: state.context));
    add(Boundary(context: state.context)..priority = 5);
    add(VoiceIndicator(state: state, note: state.note));

    for(String noteString in state.noteStrings){
      add(NoteIndicator.fromNoteString(noteString, state));
    }

  }

  @override
  void update(double dt) {

    if(state.recording || state.playing){
      state.timeElapsed += dt;
    } else {
      state.timeElapsed = 0;
    }
    super.update(dt);
  }
}