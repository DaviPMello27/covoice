import 'package:covoice/entities/note.dart';

abstract class IFFmpegModel {
  Future<String> transformIntoHarmony(String path, List<Note> notes, String key);
}