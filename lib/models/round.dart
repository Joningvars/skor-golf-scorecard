import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';

class Round {
  final String id;
  final GolfCourse golfcourse;
  final List<Player> players;
  final List<Hole> holes;
  int totalRelativeScore;

  Round({
    required this.id,
    required this.golfcourse,
    required this.players,
    required this.holes,
    this.totalRelativeScore = 0,
  });

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      id: json['id'],
      golfcourse: GolfCourse.fromJson(json['golfcourse']),
      players: (json['players'] as List)
          .map((playerJson) => Player.fromJson(playerJson))
          .toList(),
      holes: (json['holes'] as List)
          .map((holeJson) => Hole.fromJson(holeJson))
          .toList(),
      totalRelativeScore: json['totalRelativeScore'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'golfcourse': golfcourse.toJson(),
      'players': players.map((player) => player.toJson()).toList(),
      'holes': holes.map((hole) => hole.toJson()).toList(),
      'totalRelativeScore':
          totalRelativeScore, // Include totalRelativeScore in serialization
    };
  }
}
