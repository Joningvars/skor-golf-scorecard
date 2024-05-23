class Player {
  final String firstName;
  final String lastName;
  String initials;
  List<int> strokes = List.generate(18, (i) => 0);
  int selectedTee;
  int relativeScore;

  Player({
    required this.firstName,
    required this.lastName,
    this.relativeScore = 0,
    required this.strokes,
    required this.selectedTee,
    this.initials = '',
  }) {
    calculateInitials();
  }

  void addStrokes(int holeNumber, int strokes) {
    if (holeNumber < 1 || holeNumber > 18) {
      return;
    }

    this.strokes[holeNumber - 1] = strokes;
  }

  void calculateInitials() {
    List<String> words = '$firstName $lastName'.split(' ');

    words = words.where((word) => word.isNotEmpty).toList();

    initials = words.map((word) => word[0]).join().toUpperCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'strokes': strokes,
      'selectedTee': selectedTee,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      firstName: json['firstName'],
      lastName: json['lastName'],
      strokes: List<int>.from(json['strokes'] ?? []),
      selectedTee: json['selectedTee'],
    );
  }
}
