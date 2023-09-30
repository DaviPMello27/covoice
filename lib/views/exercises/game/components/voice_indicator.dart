import 'dart:math';

import 'package:covoice/entities/note.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VoiceIndicator extends PositionComponent with HasGameRef {
  BuildContext context;
  Note note;
  VoiceIndicator({required this.note, required this.context}) : super();

  @override
  Future<void>? onLoad() {
    add(
      CircleComponent(
        position: Vector2(gameRef.size.x * 0.15 - 7, 0),
        radius: 7,
        paint: Paint()..color = Theme.of(context).colorScheme.onSecondary,
      )
    );
    return super.onLoad();
  }

  double logBase(num x, num base) => log(x) / log(base);

  @override
  void update(double dt) {
    if((note.getFrequency ?? 0) > 0){
      position.y = gameRef.size.y - ((logBase(note.getFrequency!, 2) * 240) - 1820);
    }
    super.update(dt);
  } 
}
