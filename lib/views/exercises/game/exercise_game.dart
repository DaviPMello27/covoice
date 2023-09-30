import 'package:covoice/entities/note.dart';
import 'package:covoice/views/exercises/game/components/boundary.dart';
import 'package:covoice/views/exercises/game/components/target_line.dart';
import 'package:covoice/views/exercises/game/components/voice_indicator.dart';
import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

class ExerciseGame extends FlameGame {
  Note note;
  BuildContext context;

  ExerciseGame({required this.note, required this.context}) : super();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(
      RectangleComponent(
        position: Vector2(0, 0),
        size: Vector2(size.x, size.y),
        paint: Paint()..color = Theme.of(context).colorScheme.surface
      )
    );

    add(TargetLine(context: context));
    add(Boundary(context: context));

  }

  @override
  void update(double dt) {
    if((note.getFrequency ?? 0) > 0){
      add(VoiceIndicator(context: context, note: note));
    }
    super.update(dt);
  }
}