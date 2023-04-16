import 'package:record/record.dart';

abstract class IRecordingController {
  Future startRecordingStream(Function(List<Object>) onStateChanged, Function(Amplitude) onAmplitudeChanged);
  Future<String?> stopRecordingStream();

  List<String> getKeys();
}