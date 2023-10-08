import 'package:covoice/model/music_model_inteface.dart';

import 'music_controller_inteface.dart';

class MusicController implements IMusicController {
  IMusicModel musicModel;

  MusicController(this.musicModel);

  @override
  List<String> getNotes() {
    return musicModel.getNotes();
  }

  @override
  List<double> getFrequencies() {
    return musicModel.getFrequencies();
  }

  @override
  double getNearestFrequency(double frequency) {
    return musicModel.getNearestFrequency(frequency);
  }

  @override
  String getNearestNote(double frequency) {
    return musicModel.getNearestNote(frequency);
  }

  @override
  String getNearestNoteInKey(double frequency, String key) {
    return musicModel.getNearestNoteInKey(frequency, key);
  }

  @override
  void setKey(String key){
    return musicModel.setKey(key);
  }
  
}

