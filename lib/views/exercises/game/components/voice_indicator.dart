import 'dart:math';

import 'package:covoice/entities/game_note.dart';
import 'package:covoice/entities/note.dart';
import 'package:covoice/views/exercises/game/components/boundary.dart';
import 'package:covoice/views/exercises/game/exercise_game_state.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class VoiceIndicator extends PositionComponent with HasGameRef {
  ExerciseGameState state;
  Note note;
  late double positionOffset;
  VoiceIndicator({required this.note, required this.state}) : super();

  @override
  Future<void>? onLoad() {
    Color trueVoiceIndicatorColor = Theme.of(state.context).colorScheme.onSecondary;
    Color oneOctaveVoiceIndicatorColor = trueVoiceIndicatorColor
      .withRed((trueVoiceIndicatorColor.red * 0.6).round())
      .withGreen((trueVoiceIndicatorColor.green * 0.6).round())
      .withBlue((trueVoiceIndicatorColor.blue * 0.6).round());
    Color twoOctavesVoiceIndicatorColor = trueVoiceIndicatorColor
      .withRed((trueVoiceIndicatorColor.red * 0.4).round())
      .withGreen((trueVoiceIndicatorColor.green * 0.4).round())
      .withBlue((trueVoiceIndicatorColor.blue * 0.4).round());

    int initialNotePosition = GameNote.range.indexOf(state.displayedNotes.last);
    int defaultNotePosition = GameNote.range.indexOf('F3');
    int noteOffset = defaultNotePosition - initialNotePosition;
    positionOffset = (2660 + Boundary.noteLabelHeight * noteOffset) + noteOffset * 2;

    //two octaves lower
    add(
      CircleComponent(
        position: Vector2(gameRef.size.x * 0.15 - 7, Boundary.noteLabelHeight * 24),
        radius: 7,
        paint: Paint()..color = twoOctavesVoiceIndicatorColor,
      )
    );

    //one octave lower
    add(
      CircleComponent(
        position: Vector2(gameRef.size.x * 0.15 - 7, Boundary.noteLabelHeight * 12),
        radius: 7,
        paint: Paint()..color = oneOctaveVoiceIndicatorColor,
      )
    );

    //actual frequency
    add(
      CircleComponent(
        position: Vector2(gameRef.size.x * 0.15 - 7, 0),
        radius: 7,
        paint: Paint()..color = trueVoiceIndicatorColor,
      )
    );

    //one octave higher
    add(
      CircleComponent(
        position: Vector2(gameRef.size.x * 0.15 - 7, -Boundary.noteLabelHeight * 12),
        radius: 7,
        paint: Paint()..color = oneOctaveVoiceIndicatorColor,
      )
    );

    //two octaves higher
    add(
      CircleComponent(
        position: Vector2(gameRef.size.x * 0.15 - 7, -Boundary.noteLabelHeight * 24),
        radius: 7,
        paint: Paint()..color = twoOctavesVoiceIndicatorColor,
      )
    );
    return super.onLoad();
  }

  double logBase(num x, num base) => log(x) / log(base);

  //TODO: Improve these calculations. Maybe change the logic.
  double calculateVoiceIndicatorPosition(){
    double logMultiplier = 360; //360 so the difference between the notes is always 30 (Boundary.noteLabelHeight)
    
    return gameRef.size.y - ((logBase(note.getFrequency!, 2) * logMultiplier) - positionOffset);
  }

  @override
  void update(double dt) {
    if((note.getFrequency ?? 0) > 0){
      double positionY = calculateVoiceIndicatorPosition();

      position.y = positionY;

      GameNote? currentNote = state.getCurrentNote();
      if(currentNote != null){
        double currentNoteHeight = Boundary.noteLabelHeight + (Boundary.noteLabelHeight * state.displayedNotes.indexOf(currentNote.note));

        List<double> voiceIndicatorPositions = [
          positionY - Boundary.noteLabelHeight * 24,
          positionY - Boundary.noteLabelHeight * 12,
          positionY,
          positionY + Boundary.noteLabelHeight * 12,
          positionY + Boundary.noteLabelHeight * 24,
        ];

        if(voiceIndicatorPositions.any((pos) => pos > currentNoteHeight && pos < currentNoteHeight + Boundary.noteLabelHeight)){
          state.score += dt * 100;
        }
      }
    }
    super.update(dt);
  } 
}
