import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';

class Round {
  final GolfCourse golfcourse;
  final List<Player> players;
  final List<List<int>> scores;
  final String selectedTeeDistance;

  Round({
    required this.golfcourse,
    required this.players,
    required this.scores,
    required this.selectedTeeDistance,
  });
}

class HoleScore {
  final Hole hole;
  final int score;

  HoleScore({
    required this.hole,
    required this.score,
  });
}
