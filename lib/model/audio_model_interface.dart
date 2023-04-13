abstract class IAudioModel {
  Future recordStream(Function(List<Object>) onStateChanged);
  void transformAudio();

  List<String> getKeys();
}