import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/models/round.dart';
import 'package:uuid/uuid.dart';

class RoundNotifier extends StateNotifier<Round?> {
  RoundNotifier() : super(null);

  void startRound(
      GolfCourse golfCourse, List<Player> players, List<Hole> holes) {
    state = Round(
      id: const Uuid().v4(),
      golfcourse: golfCourse,
      players: players,
      holes: holes,
      date: DateTime.now().toIso8601String(),
    );
  }

  void updateScore(int playerIndex, int holeIndex, int score) {
    if (state != null) {
      state!.players[playerIndex].strokes[holeIndex] = score;
      state = state; //updating state
    }
  }

  void endRound() {
    state = null;
  }
}

final roundProvider = StateNotifierProvider<RoundNotifier, Round?>((ref) {
  return RoundNotifier();
});
