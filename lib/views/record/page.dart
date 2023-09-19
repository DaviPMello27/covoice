import 'dart:developer';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:covoice/enums/voice_type.dart';
import 'package:covoice/views/record/widgets/page_flag_button.dart';
import 'package:covoice/views/record/widgets/voice_type_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import 'package:covoice/controller/ffmpeg_controller_inteface.dart';
import 'package:covoice/controller/music_controller_inteface.dart';
import 'package:covoice/controller/player_controller_inteface.dart';
import 'package:covoice/controller/recording_controller_interface.dart';
import 'package:covoice/entities/note.dart';
import 'package:covoice/views/record/widgets/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitch_detector_dart/pitch_detector_result.dart';
import './widgets/key_roller_list.dart';
import './widgets/record_button.dart';

class MainPage extends StatefulWidget {
  final IRecordingController recordingController;
  final IPlayerController playerController;
  final IMusicController musicController;
  final IFFmpegController ffmpegController;
  const MainPage({required this.recordingController, required this.playerController, required this.musicController, required this.ffmpegController, Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String key = 'C';
  bool isRecording = false;
  String? lastNote;
  List<Note> noteList = [];
  DateTime? recordingStartTime;
  PlayerController waveFormController = PlayerController();
  String? originalAudioPath;
  String? transformedAudioPath;
  String? joinedAudioPath;
  VoiceType chosenVoiceType = VoiceType.both;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Covoice'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => 
        SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: constraints.maxHeight),
            child: Container(
              color: Theme.of(context).backgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      subtitle('Choose the song\'s key'),
                      SizedBox(
                        height: 100,
                        child: CupertinoPicker(
                          itemExtent: 30,
                          onSelectedItemChanged: (int index){
                            setState(() {
                              key = widget.musicController.getNotes()[index];
                            });
                          },
                          looping: true,
                          magnification: 1.22,
                          useMagnifier: true,
                          squeeze: 1.2,
                          scrollController: FixedExtentScrollController(
                            initialItem: 0,
                          ),
                          children: widget.musicController.getNotes().map(
                            (note) => Text(
                              note,
                              style: Theme.of(context).textTheme.bodyText1,
                            )
                          ).toList()
                        ),
                      ),
                      subtitle('and click the button below to start recording.'),
                      RecordButton(
                        onTap: () async {
                          if(isRecording){
                            log("what");
                            await stopRecording();
                          } else {
                            await startRecording();
                          }
                        },
                        isRecording: isRecording,
                      ),
                      Container(height: 30),
                      Visibility(
                        child: Player(controller: waveFormController),
                        visible: !isRecording && noteList.isNotEmpty,
                      ),
                      Visibility(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              VoiceTypeButton(
                                voiceType: VoiceType.primary,
                                selected: chosenVoiceType == VoiceType.primary,
                                onTap: () async {
                                  setState(() {
                                    chosenVoiceType = VoiceType.primary;
                                  });

                                  await waveFormController.stopPlayer();
                                  await waveFormController.preparePlayer(
                                    path: originalAudioPath!,
                                    shouldExtractWaveform: true,
                                    noOfSamples: 25,
                                    volume: 1.0,
                                  );
                                },
                              ),
                              VoiceTypeButton(
                                voiceType: VoiceType.both,
                                selected: chosenVoiceType == VoiceType.both,
                                onTap: () async {
                                  setState(() {
                                    chosenVoiceType = VoiceType.both;
                                  });

                                  await waveFormController.stopPlayer();
                                  await waveFormController.preparePlayer(
                                    path: joinedAudioPath!,
                                    shouldExtractWaveform: true,
                                    noOfSamples: 25,
                                    volume: 1.0,
                                  );
                                },
                              ),
                              VoiceTypeButton(
                                voiceType: VoiceType.secondary,
                                selected: chosenVoiceType == VoiceType.secondary,
                                onTap: () async {
                                  setState(() {
                                    chosenVoiceType = VoiceType.secondary;
                                  });

                                  await waveFormController.stopPlayer();
                                  await waveFormController.preparePlayer(
                                    path: transformedAudioPath!,
                                    shouldExtractWaveform: true,
                                    noOfSamples: 25,
                                    volume: 1.0,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        visible: !isRecording && noteList.isNotEmpty,
                      ),
                      Visibility(
                        child: Text(lastNote ?? '', style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 48)),
                        visible: isRecording,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 60),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                PageFlagButton(
                                  onPressed: (){
                                    Navigator.of(context).pushNamed('/exercises');
                                  },
                                  color: Theme.of(context).textTheme.subtitle1!.color!,
                                  iconColor: Theme.of(context).backgroundColor,
                                  icon: Icons.checklist,
                                ),
                                PageFlagButton(
                                  onPressed: (){
                                    Navigator.of(context).pushNamed('/learn');
                                  },
                                  color: Theme.of(context).textTheme.subtitle1!.color!,
                                  iconColor: Theme.of(context).backgroundColor,
                                  icon: Icons.school,
                                  flip: true
                                ),
                              ]
                            ),
                          ),
                        )
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future stopRecording() async {
    originalAudioPath = await widget.recordingController.stopRecordingStream();
    
    noteList.add(
      Note(
        note: lastNote,
        time: DateTime.now().difference(recordingStartTime!).inMilliseconds / 1000,
      )
    );

    List<Note> newNoteList = [];
    noteList.asMap().forEach((index, note) {
      if(index < noteList.length - 1){
        if(noteList[index + 1].getTime - note.getTime > 0.2){
          newNoteList.add(note);
        }
      } else {
        newNoteList.add(note);
      }
    });


    setState(() {
      isRecording = false;
    });

    if(originalAudioPath != null){
      transformedAudioPath = await widget.ffmpegController.transformIntoHarmony(originalAudioPath!, newNoteList, key);
      joinedAudioPath = await widget.ffmpegController.overlayAudios(originalAudioPath!, transformedAudioPath!);

      waveFormController.preparePlayer(
        path: joinedAudioPath!,
        shouldExtractWaveform: true,
        noOfSamples: 25,
        volume: 1.0,
      );
    } 
  }

  Future startRecording() async {
    setState(() {
      noteList = [];
      isRecording = true;
      lastNote = null;
    });
    
    noteList.add(
      Note(
        note: null,
        time: 0,
        frequency: null,
      )
    );

    widget.musicController.setKey(key);
    
    await widget.recordingController.startRecordingStream(
      (frequency){
        DateTime currentTime = DateTime.now();
        if(frequency != -1.0 && frequency > 100 && frequency < 800){
          String note = widget.musicController.getNearestNoteInKey(frequency, key);
          if(lastNote != note && recordingStartTime != null){
            setState(() {
              noteList.add(
                Note(
                  note: note,
                  time: currentTime.difference(recordingStartTime!).inMilliseconds / 1000,
                  frequency: frequency,
                )
              );
              lastNote = note;
            });
          }
        }
      },
      (amp){
        /* log("Amp $amp"); */
      }
    );
    setState(() {
      recordingStartTime = DateTime.now();
    });
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
