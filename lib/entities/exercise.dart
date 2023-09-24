class Exercise {
  late String _title;
  late int _stars;

  Exercise({required String title, required int stars}){
    _title = title;
    _stars = stars;
  }

  String get getTitle => _title;

  set setTitle(String title){
    _title = title;
  }

  int get getStars => _stars;

  set setStars(int stars){
    _stars = stars;
  }
}