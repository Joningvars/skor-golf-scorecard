import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:score_card/models/player.dart';

class PlayerList extends StateNotifier<List<Player>> {
  PlayerList() : super([]) {
    loadPlayers();
  }

  Future<void> loadPlayers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? playerJsonList = prefs.getStringList('players');
    if (playerJsonList != null) {
      state = playerJsonList
          .map((jsonString) => Player.fromJson(json.decode(jsonString)))
          .toList();
    }
  }

  Future<void> savePlayers() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> playerJsonList =
        state.map((player) => json.encode(player.toJson())).toList();
    await prefs.setStringList('players', playerJsonList);
  }

  void addPlayer(Player player) {
    state = [...state, player];
    savePlayers();
  }

  void updatePlayer(int index, Player player) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index) player else state[i]
    ];
    savePlayers();
  }

  void removePlayer(Player player) {
    state = state.where((p) => p != player).toList();
    savePlayers();
  }
}

final playerListProvider = StateNotifierProvider<PlayerList, List<Player>>(
  (ref) {
    return PlayerList();
  },
);
