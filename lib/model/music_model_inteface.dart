abstract class IMusicModel {
  List<String> getNotes();
  String getCorrectedNote(String note);
  String getMajorThird(String note);
  String getMinorThird(String note);
  bool isMajor(String note, String key);

  List<double> getFrequencies();
  double getNearestFrequency(double frequency);
  String getNearestNote(double frequency);
  String getNearestNoteInKey(double frequency, String key);
  void setKey(String key);
}