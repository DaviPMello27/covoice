import 'package:flutter_fft/flutter_fft.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:record/record.dart';

import 'player_model_inteface.dart';
import 'recording_model_interface.dart';
import 'package:just_audio/just_audio.dart';

/*
Alternative:
flutter_audio_capture (https://pub.dev/packages/flutter_audio_capture/example)
         +
pitch_detector_dart (https://pub.dev/packages/pitch_detector_dart)
https://techpotatoes.com/2021/07/27/implementing-a-guitar-tuner-app-in-dart-flutter/
*/

class PlayerModel implements IPlayerModel {
  @override
  Future playAudio(String path) {
    final AudioPlayer player = AudioPlayer();
    player.setFilePath(path);
    return player.play();
  }

  @override
  Future playAudiosTogether(String path1, String path2) async {
    final AudioPlayer player = AudioPlayer();
    player.setFilePath(path1);

    final AudioPlayer player2 = AudioPlayer();
    player2.setFilePath(path2);
    await Future.wait([player.play(), player2.play()]);
    return;
  }
  
}

