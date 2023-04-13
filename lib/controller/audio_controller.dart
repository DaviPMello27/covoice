import 'package:covoice/controller/audio_controller_interface.dart';
import 'package:covoice/model/audio_model_interface.dart';

class AudioController implements IAudioController {
  IAudioModel audioModel;

  AudioController(this.audioModel);

  @override
  Future recordStream(Function(List<Object>) onStateChanged){
    return audioModel.recordStream(onStateChanged);
  }

  @override
  void transformAudio() {
    // TODO: implement transformAudio
  }

  @override
  List<String> getKeys() {
    return audioModel.getKeys();
  }
}