abstract class IMusicModel {
  List<String> getNotes();
  bool isMajor(String note, String key);

  List<double> getFrequencies();
  double getNearestFrequency(double frequency);
  String getNearestNote(double frequency);
  String getNearestNoteInKey(double frequency, String key);
  void setKey(String key);
}