import 'dart:ffi';

class Note {
  late String? _note;
  late double _time;
  double? _frequency;

  Note({String? note, required double time, double? frequency}){
    _note = note;
    _time = time;
    _frequency = frequency;
  }

  String? get getNote => _note;

  set setNote(String? note){
    _note = note;
  }

  double get getTime => _time;

  set setTime(double time){
    _time = time;
  }

  double? get getFrequency => _frequency;

  set setFrequency(double? frequency){
    _frequency = frequency;
  }
}