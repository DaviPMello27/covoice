import 'dart:ffi';

import 'package:flutter_fft/flutter_fft.dart';

import 'audio_model_interface.dart';

class AudioModel implements IAudioModel {
  static FlutterFft? _flutterFft;

  static FlutterFft getFlutterFftInstance(){
    AudioModel._flutterFft ??= FlutterFft();
    return AudioModel._flutterFft!;
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
  Future<void> recordStream(Function(List<Object>) onStateChanged) async {
    print(getFlutterFftInstance());
    getFlutterFftInstance().startRecorder();
    getFlutterFftInstance().onRecorderStateChanged.listen(
      (data) {
        print('Received state $data');
        onStateChanged(data);
      }
    );
    getFlutterFftInstance().stopRecorder();
  }

  @override
  void recordAudio() {
    // TODO: implement recordAudio
  }

  @override
  void transformAudio() {
    // TODO: implement transformAudio
  }

  @override
  List<String> getKeys() {
    return ['C', 'C#/Db', 'D', 'D#/Eb', 'E', 'F', 'F#/Gb', 'G', 'G#/Ab', 'A', 'A#/Bb', 'B'];
  }
  
}