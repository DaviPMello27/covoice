import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class TargetLine extends RectangleComponent with HasGameRef {
  BuildContext context;

  TargetLine({required this.context}) : super();
  
  @override
  Future<void>? onLoad() {
    add(
      RectangleComponent(
        position: Vector2(gameRef.size.x * 0.15, 0),
        size: Vector2(1, gameRef.size.y),
        paint: Paint()..color = Theme.of(context).colorScheme.onSecondary,
      )
    );
    return super.onLoad();
  }
}