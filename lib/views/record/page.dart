import 'dart:developer';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:covoice/controller/ffmpeg_controller_inteface.dart';
import 'package:covoice/controller/music_controller_inteface.dart';
import 'package:covoice/controller/player_controller_inteface.dart';
import 'package:covoice/controller/recording_controller_interface.dart';
import 'package:covoice/entities/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitch_detector_dart/pitch_detector_result.dart';
import './widgets/key_roller_list.dart';
import './widgets/record_button.dart';

class MainPage extends StatefulWidget {
  final IRecordingController recordingController;
  final IPlayerController playerController;
  final IMusicController musicController;
  final IFFmpegController ffmpegController;
  MainPage({required this.recordingController, required this.playerController, required this.musicController, required this.ffmpegController, Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String key = 'C';
  bool isRecording = false;
  String? lastNote;
  List<Note> noteList = [];
  DateTime? recordingStartTime;

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
                  KeyRollerList(
                    keys: widget.musicController.getNotes(),
                    onSelect: (key){
                      setState(() {
                        this.key = key;
                      });
                    },
                  ),
                  subtitle('and click the button below to start recording.'),
                  RecordButton(
                    onTap: () async {
                      if(isRecording){
                        await stopRecording();
                      } else {
                        setState(() {
                          recordingStartTime = DateTime.now();
                          isRecording = true;
                          lastNote = null;
                          noteList.add(
                            Note(
                              note: null,
                              time: 0,
                              frequency: null,
                            )
                          );
                        });
                        
                        await widget.recordingController.startRecordingStream(
                          (frequency){
                            if(frequency != -1.0){
                              String note = widget.musicController.getNearestNote(frequency);
                              if(lastNote != note && recordingStartTime != null){
                                setState(() {
                                  noteList.add(
                                    Note(
                                      note: note,
                                      time: DateTime.now().difference(recordingStartTime!).inMilliseconds / 1000,
                                      frequency: frequency,
                                    )
                                  );
                                  lastNote = note;
                                });
                              }
                            }
                          },
                          /* (pitchData) {
                            if(pitchData.isNotEmpty && (pitchData[1] as double) > 100){
                              String note = widget.musicController.getNearestNote(pitchData[1] as double);
                              if(lastNote != note && recordingStartTime != null){
                                setState(() {
                                  noteList.add(
                                    Note(
                                      note: note,
                                      time: DateTime.now().difference(recordingStartTime!).inMilliseconds / 1000,
                                      frequency: pitchData[1] as double,
                                    )
                                  );
                                  lastNote = note;
                                });
                              }
                            }
                          },  */
                          (amp){
                            log("Amp $amp");
                          });
                      }
                    },
                    isRecording: isRecording,
                  ),
                  Container(height: 30,),
                  Text(lastNote ?? '', style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 48)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future stopRecording() async {
    String? path = await widget.recordingController.stopRecordingStream();
    log(path ?? 'null');
    noteList.add(
      Note(
        note: lastNote,
        time: DateTime.now().difference(recordingStartTime!).inMilliseconds / 1000,
      )
    );

    List<Note> newNoteList = [];
    noteList.asMap().forEach((index, note) {
      if(index < noteList.length - 1){
        if(noteList[index + 1].getTime - note.getTime > 0.5){
          newNoteList.add(note);
        }
      } else {
        newNoteList.add(note);
      }
    });


    setState(() {
      isRecording = false;
    });
    if(path != null){
      String newPath = await widget.ffmpegController.transformIntoHarmony(path, newNoteList, key);
      widget.playerController.playAudio(newPath);
    }
    noteList = [];
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
