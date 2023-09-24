import 'package:covoice/controller/ffmpeg_controller.dart';
import 'package:covoice/controller/music_controller.dart';
import 'package:covoice/controller/player_controller.dart';
import 'package:covoice/controller/recording_controller.dart';
import 'package:covoice/model/ffmpeg_model.dart';
import 'package:covoice/model/music_model.dart';
import 'package:covoice/model/player_model.dart';
import 'package:covoice/model/recording_model.dart';
import 'package:covoice/views/exercises/exercise_modules_list_page.dart';
import 'package:flutter/material.dart';
import './record/page.dart';
import './themes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MainPage home = MainPage(
        recordingController: RecordingController(RecordingModel()),
        playerController: PlayerController(PlayerModel()),
        musicController: MusicController(MusicModel()),
        ffmpegController: FFmpegController(FFmpegModel(musicModel: MusicModel())),
      );

    return MaterialApp(
      initialRoute: '/record',
      routes: {
        '/record': (context) => home,
        '/exercises': (context) => const ExerciseModulesListPage(),
        '/learn': (context) => const ExerciseModulesListPage(), //TODO: change page
      },
      debugShowCheckedModeBanner: false,
      title: 'Covoice',
      darkTheme: VoicifyTheme.dark,
      theme: VoicifyTheme.dark,
      home: home,
    );
  }
}
