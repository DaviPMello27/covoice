import 'dart:developer';

import 'package:covoice/entities/note.dart';
import 'package:covoice/model/config_model_interface.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ffmpeg_model_inteface.dart';
import 'music_model_inteface.dart';

class ConfigModel implements IConfigModel {
  static SharedPreferences? _sharedPreferences;

  Future<SharedPreferences> _getSharedPreferencesInstance() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
    return _sharedPreferences!;
  }

  @override
  Future<bool?> getBoolProperty(String property) async {
    return (await _getSharedPreferencesInstance()).getBool(property);
  }

  @override
  Future setBoolProperty(String property, bool value) async {
    return (await _getSharedPreferencesInstance()).setBool(property, value);
  }

}
