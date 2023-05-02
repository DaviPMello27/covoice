import 'package:record/record.dart';

abstract class IRecordingModel {
  Future startRecordingStream(Function(double) onFrequencyChanged, Function(Amplitude) onAmplitudeChanged);
  Future<String?> stopRecordingStream();

  List<String> getKeys();
}