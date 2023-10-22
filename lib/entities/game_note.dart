class GameNote {
  String note;
  int start;
  int end;
  bool counts;

  GameNote({required this.note, required this.start, required this.end, this.counts = true});

  //TODO: Consider putting all notes
  static List<String> range = ['D5', 'C#5', 'C5', 'B4', 'A#4', 'A4', 'G#4', 'G4', 'F#4', 'F4', 'E4', 'D#4', 'D4', 'C#4', 'C4', 'B3', 'A#3', 'A3', 'G#3', 'G3', 'F#3', 'F3', 'E3', 'D#3', 'D3', 'C#3', 'C3', 'B2'];

  static getMaxIndexFromRange(List<GameNote> gameNoteList){
    int maxIndex = 0;
    for(GameNote gameNote in gameNoteList){
      int currentIndex = range.indexOf(gameNote.note);
      if(currentIndex > maxIndex){
        maxIndex = currentIndex;
      }
    }
    return maxIndex;
  }

  static getMinIndexFromRange(List<GameNote> gameNoteList){
    int minIndex = range.length - 1;
    for(GameNote gameNote in gameNoteList){
      int currentIndex = range.indexOf(gameNote.note);
      if(currentIndex < minIndex){
        minIndex = currentIndex;
      }
    }
    return minIndex;
  }

  static GameNote fromString(String string){
    bool counts = true;
    const int delay = 150;
    String note = string.substring(0, string.indexOf('['));
    if(note[0] == 'x'){
      counts = false;
      note = note.replaceAll('x', '');
    }
    String start = string.substring(string.indexOf('[') + 1, string.indexOf('-'));
    String end = string.substring(string.indexOf('-') + 1, string.indexOf(']'));

    return GameNote(
      note: note, 
      start: int.parse(start) + delay, 
      end: int.parse(end) + delay,
      counts: counts,
    );
  }
}