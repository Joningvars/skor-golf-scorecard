class Player {
  final String name;
  String initials;
  List<int> strokes = List.generate(18, (i) => 0);

  Player({
    required this.name,
    required this.strokes,
    this.initials = '',
  });

  void addStrokes(int holeNumber, int strokes) {
    if (holeNumber < 1 || holeNumber > 18) {
      print('Hole number is not between 1 and 18');
      return;
    }

    this.strokes[holeNumber - 1] = strokes;
  }

  void calculateInitials() {
    List<String> words = name.split(' ');

    initials = words.map((word) => word[0]).join();
  }
}
