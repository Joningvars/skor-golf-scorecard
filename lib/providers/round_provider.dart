import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/models/round.dart';
import 'package:uuid/uuid.dart';

class RoundNotifier extends StateNotifier<Round?> {
  RoundNotifier() : super(null);

  void startRound(GolfCourse golfCourse, List<Player> players, List<Hole> holes,
      int selectedTee) {
    state = Round(
      id: const Uuid().v4(),
      golfcourse: golfCourse,
      players: players,
      holes: holes,
      date: DateTime.now().toIso8601String(),
    );

    // tee selection for all players
    for (var player in players) {
      player.selectedTee = selectedTee;
    }
    saveRoundState();
  }

  void updateScore(Player player, int holeIndex, int score) {
    if (state != null) {
      player.strokes[holeIndex] = score;

      state = state; // updating the state
      saveRoundState();
    }
  }

  void endRound() {
    state = null;
    clearRoundState();
  }

  Future<void> saveRoundState() async {
    final prefs = await SharedPreferences.getInstance();
    if (state != null) {
      prefs.setString('saved_round', jsonEncode(state!.toJson()));
    }
  }

  Future<void> clearRoundState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('saved_round');
  }

  Future<void> loadSavedRound() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('saved_round')) {
      final savedRound = prefs.getString('saved_round');
      if (savedRound != null) {
        state = Round.fromJson(jsonDecode(savedRound));
      }
    }
  }
}

final roundProvider = StateNotifierProvider<RoundNotifier, Round?>((ref) {
  return RoundNotifier();
});
