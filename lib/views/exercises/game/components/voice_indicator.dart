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

  //TODO: Remove when there's no more need to count maximum score
  double totalScore = 0;

  void drawVoiceIndicator(double height, Color color){
    double wholeComponentHeight = Boundary.noteLabelHeight;
    add(
      CircleComponent(
        position: Vector2(gameRef.size.x * 0.15 - 4, height - (wholeComponentHeight / 2)),
        radius: 4,
        paint: Paint()..color = color,
      )
    );

    add(
      RectangleComponent(
        position: Vector2(gameRef.size.x * 0.15 - 4, height - (wholeComponentHeight / 2) + 4),
        size: Vector2(8, wholeComponentHeight),
        paint: Paint()..color = color,
      )
    );

    add(
      CircleComponent(
        position: Vector2(gameRef.size.x * 0.15 - 4, height + (wholeComponentHeight / 2)),
        radius: 4,
        paint: Paint()..color = color,
      )
    );
  }

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

    //TODO: Adapt calculations to fit to smaller screens
    int initialNotePosition = GameNote.range.indexOf(state.displayedNotes.last);
    int defaultNotePosition = GameNote.range.indexOf('F3');
    int noteOffset = defaultNotePosition - initialNotePosition;
    positionOffset = (2660 + Boundary.noteLabelHeight * noteOffset) + noteOffset * 2;

    drawVoiceIndicator(Boundary.noteLabelHeight * 24, twoOctavesVoiceIndicatorColor);
    drawVoiceIndicator(Boundary.noteLabelHeight * 12, oneOctaveVoiceIndicatorColor);
    drawVoiceIndicator(0, trueVoiceIndicatorColor);
    drawVoiceIndicator(-Boundary.noteLabelHeight * 12, oneOctaveVoiceIndicatorColor);
    drawVoiceIndicator(-Boundary.noteLabelHeight * 24, twoOctavesVoiceIndicatorColor);

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

      List<GameNote> currentNotes = state.getCurrentCountingNotes();
      if(currentNotes.isNotEmpty){
        //TODO: Remove when there's no more need to count maximum score
        totalScore += dt * 100;
        //print(totalScore);

        List<double> voiceIndicatorPositions = [
          positionY - Boundary.noteLabelHeight * 24,
          positionY - Boundary.noteLabelHeight * 12,
          positionY,
          positionY + Boundary.noteLabelHeight * 12,
          positionY + Boundary.noteLabelHeight * 24,
        ];

        for(GameNote currentNote in currentNotes){
          double currentNoteHeight = Boundary.noteLabelHeight + (Boundary.noteLabelHeight * state.displayedNotes.indexOf(currentNote.note));

          if(voiceIndicatorPositions.any((pos) => pos > currentNoteHeight && pos < currentNoteHeight + Boundary.noteLabelHeight)){
            state.score += dt * 100;
            break;
          }

        }
      }
    }
    super.update(dt);
  } 
}
