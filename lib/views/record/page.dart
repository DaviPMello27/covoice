import 'package:covoice/controller/player_controller_inteface.dart';
import 'package:covoice/controller/recording_controller_interface.dart';
import 'package:flutter/material.dart';
import './widgets/key_roller_list.dart';
import './widgets/record_button.dart';

class MainPage extends StatefulWidget {
  final IRecordingController recordingController;
  final IPlayerController playerController;
  const MainPage({required this.recordingController, required this.playerController, Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Covoice'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Theme.of(context).backgroundColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  subtitle('Choose the song\'s key'),
                  KeyRollerList(keys: widget.recordingController.getKeys()),
                  subtitle('and click the button below to start recording.'),
                  RecordButton(
                    onTap: () async {
                      if(isRecording){
                        String? path = await widget.recordingController.stopRecordingStream();
                        setState(() {
                          isRecording = false;
                        });
                        if(path != null){
                          widget.playerController.playAudio(path);
                        }
                      } else {
                        setState(() {
                          isRecording = true;
                        });
                        String? path = await widget.recordingController.startRecordingStream((p0) {}, (amp){});
                      }
                    },
                    isRecording: isRecording,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget subtitle(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
