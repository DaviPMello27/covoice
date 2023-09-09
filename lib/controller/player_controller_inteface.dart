import 'package:record/record.dart';

abstract class IPlayerController {
  Future playAudio(String path);
  Future playAudiosTogether(String path1, String path2);
}