import 'package:covoice/entities/game_note.dart';
import 'package:covoice/views/exercises/game/components/boundary.dart';
import 'package:covoice/views/exercises/game/components/note_indicator.dart';
import 'package:covoice/views/exercises/game/components/score_text.dart';
import 'package:covoice/views/exercises/game/components/target_line.dart';
import 'package:covoice/views/exercises/game/components/voice_indicator.dart';
import 'package:covoice/views/exercises/game/exercise_game_state.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class ExerciseGame extends FlameGame {
  ExerciseGameState state;
  bool canStopLooping = false;
  void Function() onEnd;

  ExerciseGame({required this.state, required this.onEnd}) : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    state.displayedNotes = Boundary.getDisplayedNoteList(size.y, state.notes);

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
    add(Boundary(state: state)..priority = 5);
    //add(ScoreText(score: state.score));

    add(VoiceIndicator(state: state, note: state.sangNote));

    for(GameNote note in state.notes){
      add(NoteIndicator.fromGameNote(note, state));
    }

  }

  @override
  void update(double dt) {
    if(state.timeElapsedInMilliseconds > 100){
      canStopLooping = true;
    }

    if(state.timeElapsedInMilliseconds < 100 && canStopLooping){
      canStopLooping = false;
      state.recording = false;
      state.playing = false;
      onEnd();
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