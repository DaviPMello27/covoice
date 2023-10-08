abstract class IMusicController {
  List<String> getNotes();

  List<double> getFrequencies();
  double getNearestFrequency(double frequency);
  String getNearestNote(double frequency);
  String getNearestNoteInKey(double frequency, String key);
  void setKey(String key);
}