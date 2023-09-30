import 'dart:math';

import 'package:covoice/model/music_model.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Boundary extends PositionComponent with HasGameRef {
  BuildContext context;

  List<String> notes = MusicModel.notes;

  final double noteLabelHeight = 30; //log(note, 2) * 360 - log(previousNote, 2) * 360 = (2891.29... - 2921.28...)
  late final Color _noteOddColor = Theme.of(context).colorScheme.secondaryVariant;
  late final Color _noteEvenColor = _noteOddColor
    .withRed(min((_noteOddColor.red * 1.3).toInt(), 255))
    .withGreen(min((_noteOddColor.green * 1.3).toInt(), 255))
    .withBlue(min((_noteOddColor.blue * 1.3).toInt(), 255));

  late final Paint noteOdd = Paint()..color = _noteOddColor;
  late final Paint noteEven = Paint()..color = _noteEvenColor;

  Boundary({required this.context}) : super();

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
    for(double i = noteLabelHeight; i <= (gameRef.size.y - noteLabelHeight); i += noteLabelHeight){
      add(
        RectangleComponent(
          position: Vector2(0, i),
          size: Vector2(noteLabelHeight * 1.3, noteLabelHeight),
          paint: i % (noteLabelHeight * 2) == 0 ? noteOdd : noteEven,
        )
      );

      add(
        TextComponent(
          position: Vector2(noteLabelHeight * 0.2, (noteLabelHeight * 0.2) + i),
          textRenderer: TextPaint(style: Theme.of(context).textTheme.subtitle2!.copyWith(fontSize: noteLabelHeight/2)),
          text: MusicModel.notes[11 - ((i / noteLabelHeight) % MusicModel.notes.length).round()]
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