import 'package:covoice/controller/ffmpeg_controller.dart';
import 'package:covoice/controller/music_controller.dart';
import 'package:covoice/controller/player_controller.dart';
import 'package:covoice/controller/recording_controller.dart';
import 'package:covoice/model/ffmpeg_model.dart';
import 'package:covoice/model/music_model.dart';
import 'package:covoice/model/player_model.dart';
import 'package:covoice/model/recording_model.dart';
import 'package:flutter/material.dart';
import './record/page.dart';
import './themes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covoice',
      darkTheme: VoicifyTheme.dark,
      theme: VoicifyTheme.dark,
      home: MainPage(
        recordingController: RecordingController(RecordingModel()),
        playerController: PlayerController(PlayerModel()),
        musicController: MusicController(MusicModel()),
        ffmpegController: FFmpegController(FFmpegModel(musicModel: MusicModel())),
      ),
    );
  }
}
