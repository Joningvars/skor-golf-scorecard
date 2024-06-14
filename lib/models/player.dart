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

  int calculateRelativeScoreFront9(List<Hole> holes) {
    int relativeScoreFront9 = 0;
    for (int i = 0; i < 9 && i < holes.length && i < strokes.length; i++) {
      if (strokes[i] > 0) {
        relativeScoreFront9 += (strokes[i] - holes[i].par);
      }
    }
    return relativeScoreFront9;
  }

  int calculateRelativeScoreBack9(List<Hole> holes) {
    int relativeScoreBack9 = 0;
    for (int i = 9; i < 18 && i < holes.length && i < strokes.length; i++) {
      if (strokes[i] > 0) {
        relativeScoreBack9 += (strokes[i] - holes[i].par);
      }
    }
    return relativeScoreBack9;
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
