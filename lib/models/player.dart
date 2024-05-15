class Player {
  final String firstName;
  final String lastName;
  String initials;
  List<int> strokes = List.generate(18, (i) => 0);
  int selectedTee;

  Player({
    required this.firstName,
    required this.lastName,
    required this.strokes,
    required this.selectedTee,
    this.initials = '',
  }) {
    calculateInitials();
  }

  void addStrokes(int holeNumber, int strokes) {
    if (holeNumber < 1 || holeNumber > 18) {
      print('Hole number is not between 1 and 18');
      return;
    }

    this.strokes[holeNumber - 1] = strokes;
  }

  void calculateInitials() {
    List<String> words = '$firstName $lastName'.split(' ');

    words = words.where((word) => word.isNotEmpty).toList();

    initials = words.map((word) => word[0]).join().toUpperCase();
  }
}
