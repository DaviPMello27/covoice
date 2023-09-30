import 'dart:math';

import 'package:covoice/entities/note.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class VoiceIndicator extends PositionComponent with HasGameRef {
  BuildContext context;
  Note note;
  VoiceIndicator({required this.note, required this.context}) : super();

  @override
  Future<void>? onLoad() {
    Color trueVoiceIndicatorColor = Theme.of(context).colorScheme.onSecondary;
    Color oneOctaveVoiceIndicatorColor = trueVoiceIndicatorColor
      .withRed((trueVoiceIndicatorColor.red * 0.6).round())
      .withGreen((trueVoiceIndicatorColor.green * 0.6).round())
      .withBlue((trueVoiceIndicatorColor.blue * 0.6).round());
    Color twoOctavesVoiceIndicatorColor = trueVoiceIndicatorColor
      .withRed((trueVoiceIndicatorColor.red * 0.4).round())
      .withGreen((trueVoiceIndicatorColor.green * 0.4).round())
      .withBlue((trueVoiceIndicatorColor.blue * 0.4).round());

    //two octaves lower
    add(
      CircleComponent(
        position: Vector2(gameRef.size.x * 0.15 - 7, 30 * 24),
        radius: 7,
        paint: Paint()..color = twoOctavesVoiceIndicatorColor,
      )
    );

    //one octave lower
    add(
      CircleComponent(
        position: Vector2(gameRef.size.x * 0.15 - 7, 30 * 12),
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
        position: Vector2(gameRef.size.x * 0.15 - 7, -30 * 12),
        radius: 7,
        paint: Paint()..color = oneOctaveVoiceIndicatorColor,
      )
    );

    //two octaves higher
    add(
      CircleComponent(
        position: Vector2(gameRef.size.x * 0.15 - 7, -30 * 24),
        radius: 7,
        paint: Paint()..color = twoOctavesVoiceIndicatorColor,
      )
    );
    return super.onLoad();
  }

  double logBase(num x, num base) => log(x) / log(base);

  @override
  void update(double dt) {
    if((note.getFrequency ?? 0) > 0){
      double positionY = gameRef.size.y - ((logBase(note.getFrequency!, 2) * 360) - 2660);
      position.y = positionY;
    }
    super.update(dt);
  } 
}
