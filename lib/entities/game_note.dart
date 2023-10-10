class GameNote {
  String note;
  int start;
  int end;

  GameNote({required this.note, required this.start, required this.end});

  static List<String> range = ['A#4', 'A4', 'G#4', 'G4', 'F#4', 'F4', 'E4', 'D#4', 'D4', 'C#4', 'C4', 'B3', 'A#3', 'A3', 'G#3', 'G3', 'F#3'];

  static GameNote fromString(String string){
    String note = string.substring(0, string.indexOf('['));
    String start = string.substring(string.indexOf('[') + 1, string.indexOf('-'));
    String end = string.substring(string.indexOf('-') + 1, string.indexOf(']'));

    return GameNote(
      note: note, 
      start: int.parse(start), 
      end: int.parse(end)
    );
  }
}