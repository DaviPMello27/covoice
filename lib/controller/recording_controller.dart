import 'package:covoice/controller/recording_controller_interface.dart';
import 'package:covoice/model/recording_model_interface.dart';
import 'package:record/record.dart';

class RecordingController implements IRecordingController {
  IRecordingModel recordingModel;

  RecordingController(this.recordingModel);

  @override
  Future startRecordingStream(Function(double) onFrequencyChanged, Function(Amplitude) onAmplitudeChanged){
    return recordingModel.startRecordingStream(onFrequencyChanged, onAmplitudeChanged); //TODO: Implement amplitude function
  }

  @override
  Future<String?> stopRecordingStream(){
    return recordingModel.stopRecordingStream();
  }

  @override
  List<String> getKeys() {
    return recordingModel.getKeys();
  }
}