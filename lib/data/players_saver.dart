import 'dart:convert';

import 'package:score_card/models/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlayerStorage {
  static const _key = 'players';

  static Future<void> savePlayers(List<Player> players) async {
    final prefs = await SharedPreferences.getInstance();
    final playersJson = players.map((player) => player.toJson()).toList();
    await prefs.setString(_key, json.encode(playersJson));
  }

  static Future<List<Player>> loadPlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playersJson = prefs.getString(_key);
    if (playersJson != null) {
      final List<dynamic> decoded = json.decode(playersJson);
      return decoded.map((json) => Player.fromJson(json)).toList();
    }
    return [];
  }
}
