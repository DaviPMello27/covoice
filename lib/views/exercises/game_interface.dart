import 'package:flame/game.dart';
import 'package:flame/geometry.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';

class ExerciseGame extends FlameGame {
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(
      RectangleComponent(
        position: Vector2(20, 20),
        size: Vector2(20, 20),
        paint: BasicPalette.red.paint()..style = PaintingStyle.fill,
      )
    );
  }
}