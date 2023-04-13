import 'package:covoice/controller/audio_controller.dart';
import 'package:covoice/model/audio_model.dart';
import 'package:flutter/material.dart';
import './record/page.dart';
import './themes.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Covoice',
      darkTheme: VoicifyTheme.dark,
      theme: VoicifyTheme.light,
      home: MainPage(audioController: AudioController(AudioModel())),
    );
  }
}
