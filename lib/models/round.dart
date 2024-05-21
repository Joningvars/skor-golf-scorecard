import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:uuid/uuid.dart'; // Import the uuid package

class Round {
  final String id; // Unique ID field added
  final GolfCourse golfcourse;
  final List<Player> players;
  final List<Hole> holes;

  Round({
    required this.id, // Ensure ID is required in the constructor
    required this.golfcourse,
    required this.players,
    required this.holes,
  });

  factory Round.fromJson(Map<String, dynamic> json) {
    return Round(
      id: json['id'], // Retrieve ID from JSON
      golfcourse: GolfCourse.fromJson(json['golfcourse']),
      players: (json['players'] as List)
          .map((playerJson) => Player.fromJson(playerJson))
          .toList(),
      holes: (json['holes'] as List)
          .map((holeJson) => Hole.fromJson(holeJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id, // Include ID in JSON serialization
      'golfcourse': golfcourse.toJson(),
      'players': players.map((player) => player.toJson()).toList(),
      'holes': holes.map((hole) => hole.toJson()).toList(),
    };
  }
}
