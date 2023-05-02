abstract class IMusicController {
  List<String> getNotes();
  String getCorrectedNote(String note);
  String getMajorThird(String note);
  String getMinorThird(String note);

  List<double> getFrequencies();
  double getNearestFrequency(double frequency);
  String getNearestNote(double frequency);
}