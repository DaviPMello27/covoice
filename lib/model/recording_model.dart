import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_audio_capture/flutter_audio_capture.dart';
import 'package:flutter_fft/flutter_fft.dart';
import 'package:flutter_voice_processor/flutter_voice_processor.dart';
import 'package:pitch_detector_dart/pitch_detector.dart';
import 'package:pitch_detector_dart/pitch_detector_result.dart';
import 'package:record/record.dart';

import 'music_model.dart';
import 'music_model_inteface.dart';
import 'recording_model_interface.dart';

class RecordingModel implements IRecordingModel {
  final double sampleRate = 22000;
  final int sampleSize = 512;

  static FlutterFft? _flutterFft;
  final FlutterAudioCapture audioCapture = FlutterAudioCapture();
  late PitchDetector pitchDetector = PitchDetector(sampleRate, sampleSize);
  final IMusicModel musicModel = MusicModel();
  final VoiceProcessor? _voiceProcessor = VoiceProcessor.instance;
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
  Future startRecordingStream(Function(double) onFrequencyChanged, Function(Amplitude)? onAmplitudeChanged) async {
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
      (error) => {log('error!')},
      sampleRate: sampleRate.toInt(),
      bufferSize: sampleSize,
    );
  }

  @override
  Future startRecordingStreamWithoutStoring(Function(double) onFrequencyChanged) async {
    await requestRecordingPermission();

    if(_voiceProcessor != null){
      _voiceProcessor!.addFrameListener((frame) {
        PitchDetectorResult result = pitchDetector.getPitch(frame.map((e) => e.toDouble()).toList());
        onFrequencyChanged(result.pitch);
      });

      _voiceProcessor!.start(sampleSize, sampleRate.toInt());
    }

    /* await audioCapture.start(
      (obj){
        var buffer = Float64List.fromList(obj.cast<double>());

        print(obj.length);
        //print(buffer.length);

        /* final List<double> audioSample = buffer.toList();
        PitchDetectorResult result = pitchDetector.getPitch(audioSample);
        print('note: ${musicModel.getNearestNote(result.pitch)}, frequency: ${result.pitch}, probability: ${result.probability}');
        if(result.probability < 0.8){
          return -1.0;
        } 
        onFrequencyChanged(result.pitch); */
      },
      (error) => {log('error!')},
      sampleRate: sampleRate.toInt(),
      bufferSize: sampleSize,
    ); */
  }

  @override
  Future stopRecordingStreamWithoutStoring() async {
    //await audioCapture.stop();
    await _voiceProcessor!.stop();
    return;
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
  List<String> getKeys() { //move somewhere
    return ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
  }
  
}
