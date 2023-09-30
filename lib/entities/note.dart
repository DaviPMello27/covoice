import 'dart:ffi';

//TODO: remove getters and setters

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

  set note(String? note){
    _note = note;
  }

  double get getTime => _time;

  set time(double time){
    _time = time;
  }

  double? get getFrequency => _frequency;

  set frequency(double? frequency){
    _frequency = frequency;
  }
}