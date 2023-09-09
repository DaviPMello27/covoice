import 'package:covoice/entities/note.dart';

abstract class IFFmpegController {
  /// Transforms given audio into its vocal hamony counterpart.
  /// 
  /// Returns the path for the output audio file.
  Future<String> transformIntoHarmony(String path, List<Note> notes, String key);
}