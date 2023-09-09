import 'dart:developer';

import 'package:flutter_fft/flutter_fft.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:record/record.dart';

import 'music_model_inteface.dart';
import 'player_model_inteface.dart';
import 'recording_model_interface.dart';
import 'package:just_audio/just_audio.dart';

/*
Alternative:
flutter_audio_capture (https://pub.dev/packages/flutter_audio_capture/example)
         +
pitch_detector_dart (https://pub.dev/packages/pitch_detector_dart)
https://techpotatoes.com/2021/07/27/implementing-a-guitar-tuner-app-in-dart-flutter/
*/

class MusicModel implements IMusicModel {
  final List<String> _notes = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];
  ///Array of frequencies, starting in C1 and ending in C8
  final List<double> _frequencies = [32.703195662574829,34.647828872109012,36.708095989675945,38.890872965260113,41.203444614108741,43.653528929125485,46.249302838954299,48.999429497718661,51.913087197493142,55.000000000000000,58.270470189761239,61.735412657015513,65.406391325149658,69.295657744218024,73.416191979351890,77.781745930520227,82.406889228217482,87.307057858250971,92.498605677908599,97.998858995437323,103.826174394986284,110.000000000000000,116.540940379522479,123.470825314031027,130.812782650299317,138.591315488436048,146.832383958703780,155.563491861040455,164.813778456434964,174.614115716501942,184.997211355817199,195.997717990874647,207.652348789972569,220.000000000000000,233.081880759044958,246.941650628062055,261.625565300598634,277.182630976872096,293.664767917407560,311.126983722080910,329.627556912869929,349.228231433003884,369.994422711634398,391.995435981749294,415.304697579945138,440.000000000000000,466.163761518089916,493.883301256124111,523.251130601197269,554.365261953744192,587.329535834815120,622.253967444161821,659.255113825739859,698.456462866007768,739.988845423268797,783.990871963498588,830.609395159890277,880.000000000000000,932.327523036179832,987.766602512248223,1046.502261202394538,1108.730523907488384,1174.659071669630241,1244.507934888323642,1318.510227651479718,1396.912925732015537,1479.977690846537595,1567.981743926997176,1661.218790319780554,1760.000000000000000,1864.655046072359665,1975.533205024496447,2093.004522404789077,2217.461047814976769,2349.318143339260482,2489.015869776647285,2637.020455302959437,2793.825851464031075,2959.955381693075191,3135.963487853994352,3322.437580639561108,3520.000000000000000,3729.310092144719331,3951.066410048992894,4186.009044809578154];
  List<double> _frequenciesInKey = [];

  String _getNoteSafe(int index){
    return getNotes()[index % _notes.length];
  }

  int _getNoteIndex(String note){
    return getNotes().indexOf(note);
  }

  void setKey(String key){
    _frequenciesInKey = [];
    int firstTonic = _notes.indexOf(key);
    List<int> intervals = [2, 4, 5, 7, 9, 11, 12];

    for(int i = firstTonic; i < _frequencies.length; i += 12){
      for(int interval in intervals){
        if((i + interval) < _frequencies.length){
          _frequenciesInKey.add(_frequencies[i + interval]);
        }
      }
    }

    /* for(double freq in _frequenciesInKey){
      log("Freq: $freq, note: ${getNearestNote(freq)}");
    } */
  }

  @override
  List<String> getNotes(){
    return _notes;
  }

  @override
  @deprecated
  String getCorrectedNote(String note) {
    return _getNoteSafe((_getNoteIndex(note) + 1));
  }

  @override
  String getMajorThird(String note) {
    return _getNoteSafe(_getNoteIndex(getCorrectedNote(note)) + 4);
  }

  @override
  String getMinorThird(String note) {
    return _getNoteSafe(_getNoteIndex(getCorrectedNote(note)) + 3);
  }

  String correctBasedOnKey(String note, String key){
    int keyIndex = _getNoteIndex(key);
    List<String> acceptables = [
      _getNoteSafe(keyIndex),
      _getNoteSafe(keyIndex + 2),
      _getNoteSafe(keyIndex + 4),
      _getNoteSafe(keyIndex + 5),
      _getNoteSafe(keyIndex + 7),
      _getNoteSafe(keyIndex + 9),
      _getNoteSafe(keyIndex + 11),
    ];

    if(!acceptables.contains(note)){
      return _getNoteSafe(_getNoteIndex(note) + 1);
    } else {
      return note;
    }

  }

  @override
  bool isMajor(String note, String key) {
    int keyIndex = _getNoteIndex(key);
    List<String> majors = [_getNoteSafe(keyIndex), _getNoteSafe(keyIndex + 5), _getNoteSafe(keyIndex + 7)];
    return majors.contains(note);
  }

  @override
  List<double> getFrequencies() {
    return _frequencies;
  }

  @override
  double getNearestFrequency(double frequency) {
    double minDifference = double.infinity;
    for(double comparingFrequency in _frequencies){
      double difference = (frequency - comparingFrequency).abs();
      if(minDifference > difference){
        minDifference = difference;
      } else {
        break;
      }
    }
    return minDifference;
  }

  @override
  String getNearestNote(double frequency) {
    int frequencyIndex = 0;
    double minDifference = double.infinity;
    _frequencies.asMap().forEach((index, comparingFrequency) {
      double difference = (frequency - comparingFrequency).abs();
      if(minDifference > difference){
        minDifference = difference;
        frequencyIndex = index;
      } else {
        return;
      }
    });
    return _getNoteSafe(frequencyIndex);
  }

  @override
  String getNearestNoteInKey(double frequency, String key) {
    if(_frequenciesInKey.isEmpty){
      throw Exception('Key was not set. You can set it by calling musicModel.setKey');
    }
    double closestFrequency = 0;
    double minDifference = double.infinity;
    _frequenciesInKey.asMap().forEach((index, comparingFrequency) {
      double difference = (frequency - comparingFrequency).abs();
      if(minDifference > difference){
        minDifference = difference;
        closestFrequency = comparingFrequency;
      } else {
        return;
      }
    });
    return _getNoteSafe(_frequencies.indexOf(closestFrequency)); //TODO: Optimize
  }
}

