import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:flutter_fft/flutter_fft.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitch_detector_dart/pitch_detector_result.dart';
import 'package:record/record.dart';

import 'music_model.dart';
import 'music_model_inteface.dart';
import 'recording_model_interface.dart';

/*
Alternative:
flutter_audio_capture (https://pub.dev/packages/flutter_audio_capture/example)
         +
pitch_detector_dart (https://pub.dev/packages/pitch_detector_dart)
https://techpotatoes.com/2021/07/27/implementing-a-guitar-tuner-app-in-dart-flutter/
*/

class RecordingModel implements IRecordingModel {
  static FlutterFft? _flutterFft;
  final FlutterAudioCapture audioCapture = FlutterAudioCapture();
  final PitchDetector pitchDetector = PitchDetector(44100, 3000);
  final IMusicModel musicModel = MusicModel();
  //static FlutterSoundRecorder? _soundRecorder;
  static Record? _recorder;

  static FlutterFft getFlutterFftInstance(){
    RecordingModel._flutterFft ??= FlutterFft();  
    return RecordingModel._flutterFft!;
  }

  static Record getRecorderInstance(){
    RecordingModel._recorder ??= Record();
    return RecordingModel._recorder!;
  }

  Future<void> requestRecordingPermission() async {
    while(!(await getFlutterFftInstance().checkPermission())){
      getFlutterFftInstance().requestPermission();
    }
  }

  bool isRecording(){
    return getFlutterFftInstance().getIsRecording;
  }

  @override
  Future startRecordingStream(Function(double) onFrequencyChanged, Function(Amplitude) onAmplitudeChanged) async {
    await requestRecordingPermission();

    await getRecorderInstance().start();

    DateTime startTime = DateTime.now();

    getRecorderInstance().onAmplitudeChanged(const Duration(milliseconds: 200)).listen(onAmplitudeChanged);
    await audioCapture.start(
      (obj){
        var buffer = Float64List.fromList(obj.cast<double>());
        final List<double> audioSample = buffer.toList();
        PitchDetectorResult result = pitchDetector.getPitch(audioSample);
        print('note: ${musicModel.getNearestNote(result.pitch)}, timestamp: ${DateTime.now().difference(startTime).inMilliseconds}, frequency: ${result.pitch}, probability: ${result.probability}');
        if(result.probability < 0.8){
          return -1.0;
        } 
        onFrequencyChanged(result.pitch);
      },
      (error) => {log('error!')}
    );
  }

  @override
  Future<String?> stopRecordingStream() async {
    //getFlutterFftInstance().stopRecorder();
    await audioCapture.stop();
    String? path = await getRecorderInstance().stop();
    print(path);
    getRecorderInstance().dispose();
    return path;
  }

  @override
  List<String> getKeys() {
    return ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
  }
  
}

/*
0 - tolerance: Error tolerance (HZ)
1 - frequency: Detected frequency (HZ)
2 - note: Detected note (String)
3 - target: Target note (HZ. Frequency of the note that is closest to this note in the target tuning. If there's no target tuning, this frequency will be the one that's closest to the note detected)
4 - distance: Absolute distance between detected and target note (HZ)
5 - octave: Detected note's octave (Integer)
6 - nearestNote: Note that is the closest to the current detected note (String)
7 - nearestTarget: Frequency of the note that is the closest to the current detected note (HZ. It seems that this will only differ from the original target if there's no current tuning target)
8 - nearestDistance: Absolute distance between detected note and the nearest note (HZ)
9 - nearestOctave: Octave of the note that is the closest to the current detected note (Integer)
10 - isOnPitch: Whether it is considered on pitch (Boolean. If the current detected frequency is within tolerance of the nearest target note's frequency)
*/