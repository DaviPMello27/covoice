import 'package:record/record.dart';

abstract class IRecordingController {
  Future startRecordingStream(Function(double) onFrequencyChanged, Function(Amplitude) onAmplitudeChanged);
  Future<String?> stopRecordingStream();

  List<String> getKeys();
}