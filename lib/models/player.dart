import 'package:score_card/models/hole.dart';

class Player {
  final String firstName;
  final String lastName;
  String initials;
  List<int> strokes;
  int selectedTee;
  int relativeScore;

  Player({
    required this.firstName,
    required this.lastName,
    this.relativeScore = 0,
    required this.strokes,
    this.selectedTee = 0,
    this.initials = '',
  }) {
    calculateInitials();
  }

  void addStrokes(int holeNumber, int strokes, int holePar) {
    if (holeNumber < 1 || holeNumber > 18) {
      return;
    }

    int currentStrokes = this.strokes[holeNumber - 1];
    if (currentStrokes > 0) {
      relativeScore -= (currentStrokes - holePar);
    }

    this.strokes[holeNumber - 1] = strokes;
    relativeScore += (strokes - holePar);
  }

  void calculateInitials() {
    List<String> words = '$firstName $lastName'.split(' ');

    words = words.where((word) => word.isNotEmpty).toList();

    initials = words.map((word) => word[0]).join().toUpperCase();
  }

  void calculateRelativeScore(List<Hole> holes) {
    relativeScore = 0;
    for (int i = 0; i < strokes.length; i++) {
      relativeScore += (strokes[i] - holes[i].par);
    }
  }

  void resetScores() {
    strokes = List.generate(18, (i) => 0);
    relativeScore = 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'strokes': strokes,
      'selectedTee': selectedTee,
      'relativeScore': relativeScore,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      firstName: json['firstName'],
      lastName: json['lastName'],
      strokes: List<int>.from(json['strokes'] ?? []),
      selectedTee: json['selectedTee'],
      relativeScore: json['relativeScore'] ?? 0,
    );
  }
}
