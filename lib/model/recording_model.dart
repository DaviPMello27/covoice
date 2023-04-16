import 'package:flutter_fft/flutter_fft.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:record/record.dart';

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
  //static FlutterSoundRecorder? _soundRecorder;
  static Record? _recorder;

  static FlutterFft getFlutterFftInstance(){
    RecordingModel._flutterFft ??= FlutterFft();
    return RecordingModel._flutterFft!;
  }

  /* static FlutterSoundRecorder getRecorderInstance(){
    RecordingModel._soundRecorder ??= FlutterSoundRecorder();
    return RecordingModel._soundRecorder!;
  } */

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
  Future startRecordingStream(Function(List<Object>) onStateChanged, Function(Amplitude) onAmplitudeChanged) async {
    /* if(!await getFlutterFftInstance().checkPermission()){
      await requestRecordingPermission();
      //return null;
    } */

    await requestRecordingPermission();

    //await getRecorderInstance().openRecorder();
    await getRecorderInstance().start();
    await getFlutterFftInstance().startRecorder();
    //Actually record audio
    
    getRecorderInstance().onAmplitudeChanged(const Duration(milliseconds: 300)).listen(onAmplitudeChanged);
    getFlutterFftInstance().onRecorderStateChanged.listen(
      (data) {
        print('Received state $data');
        onStateChanged(data);
      },
      onError: (error) {
        print(error); //TODO: Implement error message.
      },
      onDone: () {
        //TODO: Finish recording
      },
    );
  }

  @override
  Future<String?> stopRecordingStream() async {
    getFlutterFftInstance().stopRecorder();
      String? path = await getRecorderInstance().stop();
      print(path);
      getRecorderInstance().dispose();
      return path;
  }

  @override
  List<String> getKeys() {
    return ['C', 'C#/Db', 'D', 'D#/Eb', 'E', 'F', 'F#/Gb', 'G', 'G#/Ab', 'A', 'A#/Bb', 'B'];
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