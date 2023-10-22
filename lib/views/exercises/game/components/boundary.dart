import 'dart:math';

import 'package:covoice/entities/game_note.dart';
import 'package:covoice/model/music_model.dart';
import 'package:covoice/views/exercises/game/exercise_game_state.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Boundary extends PositionComponent with HasGameRef {
  ExerciseGameState state;

  static const double noteLabelHeight = 30; //log(note, 2) * 360 - log(previousNote, 2) * 360 = (2891.29... - 2921.28...)
  late final Color _noteOddColor = Theme.of(state.context).colorScheme.secondaryVariant;
  late final Color _noteEvenColor = _noteOddColor
    .withRed(min((_noteOddColor.red * 1.3).toInt(), 255))
    .withGreen(min((_noteOddColor.green * 1.3).toInt(), 255))
    .withBlue(min((_noteOddColor.blue * 1.3).toInt(), 255));

  late final Paint noteOdd = Paint()..color = _noteOddColor;
  late final Paint noteEven = Paint()..color = _noteEvenColor;

  Boundary({required this.state}) : super();

  static getDisplayedNoteList(double verticalSize, List<GameNote> gameNoteList){
    int minIndex = GameNote.getMinIndexFromRange(gameNoteList);
    int maxIndex = GameNote.getMaxIndexFromRange(gameNoteList);
    double noteScopeSize = (maxIndex - (minIndex - 1)) * Boundary.noteLabelHeight;

    List<String> notes = GameNote.range.getRange(minIndex, maxIndex + 1).toList();

    double remainingSpace = verticalSize - (Boundary.noteLabelHeight * 2) - noteScopeSize;

    while(remainingSpace > 0){
      int nextUpperNoteIndex = GameNote.range.indexOf(notes.last) + 1;
      if(nextUpperNoteIndex < GameNote.range.length){
        notes.add(GameNote.range[nextUpperNoteIndex]);
      }
      remainingSpace -= Boundary.noteLabelHeight;

      int nextLowerNoteIndex = GameNote.range.indexOf(notes.first) - 1;
      if(remainingSpace > 0){
        if(nextLowerNoteIndex >= 0){
          notes = [GameNote.range[nextLowerNoteIndex], ...notes];
        }
        remainingSpace -= Boundary.noteLabelHeight;
      }
    }

    return notes;
  }

  @override
  Future<void>? onLoad() {

    //Top boundary
    add(
      RectangleComponent(
        position: Vector2(0, 0),
        size: Vector2(gameRef.size.x, noteLabelHeight),
        paint: noteEven,
      )
    );

    //Left boundary
    for(int i = 0; i < state.displayedNotes.length; i++){
      double yPosition = noteLabelHeight + (i * noteLabelHeight);
      add(
        RectangleComponent(
          position: Vector2(0, yPosition),
          size: Vector2(noteLabelHeight * 1.3, noteLabelHeight),
          paint: i % 2 == 0 ? noteOdd : noteEven,
        )
      );

      add(
        TextComponent(
          position: Vector2(noteLabelHeight * 0.2, (noteLabelHeight * 0.2) + yPosition),
          textRenderer: TextPaint(style: Theme.of(state.context).textTheme.subtitle2!.copyWith(fontSize: noteLabelHeight/2)),
          text: state.displayedNotes[i]
        )
      );
    }

    double remainingHeight = gameRef.size.y % noteLabelHeight;

    add(
      RectangleComponent(
        position: Vector2(0, gameRef.size.y - remainingHeight),
        size: Vector2(noteLabelHeight * 1.5, remainingHeight),
        paint: (gameRef.size.y - remainingHeight) % (noteLabelHeight * 2) == 0 ? noteOdd : noteEven,
      )
    );

    //Bottom boundary
    add(
      RectangleComponent(
        position: Vector2(0, gameRef.size.y - noteLabelHeight),
        size: Vector2(gameRef.size.x, noteLabelHeight),
        paint: gameRef.size.y % (noteLabelHeight * 2) == 0 ? noteOdd : noteEven,
      )
    );
    
    return super.onLoad();
  }
}