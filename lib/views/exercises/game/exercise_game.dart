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
  bool canStopLooping = false;


  ExerciseGame({required this.state}) : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    if(state.playing || state.recording){ //Maybe you'll have to move this if you manage to make the canvas not rerender
      FlameAudio.audioCache.prefix = '';
      FlameAudio.bgm.play('${state.exercise.getFullPath}/audio.mp3');
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
    if(state.timeElapsedInMilliseconds > 0){
      canStopLooping = true;
    }

    if(state.timeElapsedInMilliseconds == 0 && canStopLooping){
      canStopLooping = false;
      state.recording = false;
      state.playing = false;
      //this.onEnd();
    }

    if(state.recording || state.playing){
      FlameAudio.bgm.audioPlayer?.getCurrentPosition().then(
          (currentPos) {
            state.timeElapsedInMilliseconds = currentPos;
          }
        );
    } else {
      state.timeElapsedInMilliseconds = 0;
      if(FlameAudio.bgm.isPlaying){
        FlameAudio.bgm.stop();
      }
    }

    super.update(dt);
  }
}