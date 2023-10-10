import 'package:record/record.dart';

abstract class IRecordingModel {
  Future startRecordingStream(Function(double) onFrequencyChanged, Function(Amplitude)? onAmplitudeChanged);
  Future startRecordingStreamWithoutStoring(Function(double) onFrequencyChanged);
  Future<String?> stopRecordingStream();
  Future stopRecordingStreamWithoutStoring();

  List<String> getKeys();
}