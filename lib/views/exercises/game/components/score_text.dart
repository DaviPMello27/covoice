import 'dart:ui';

import 'package:flame/components.dart';

class ScoreText extends TextComponent with HasGameRef {
  late int score;

  late final TextPaint _textPaint;

  ScoreText({required this.score});
 
  @override
  Future<void>? onLoad() {
    score = 0;
    text = score.toString();

    return super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }
}