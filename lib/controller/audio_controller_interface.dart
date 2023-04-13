abstract class IAudioController {
  Future recordStream(Function(List<Object>) onStateChanged);
  void transformAudio();

  List<String> getKeys();
}