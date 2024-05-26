import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/models/round.dart';
import 'package:score_card/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Future<void> saveRound(BuildContext context, List<Player> players,
    List<Hole> holes, GolfCourse course) async {
  int totalStrokes = players[0].strokes.fold(0, (sum, stroke) => sum + stroke);
  int totalPar = holes.fold(0, (sum, hole) => sum + hole.par);
  int totalRelativeScore = totalStrokes - totalPar;
  String roundId = const Uuid().v4(); // unique id
  Round round = Round(
    golfcourse: course,
    players: players,
    holes: holes,
    id: roundId,
    totalRelativeScore: totalRelativeScore,
  );

  // json convert
  String roundJson = json.encode(round.toJson());

  // GET saved rounds
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? savedRoundJsonList = prefs.getStringList('savedRounds') ?? [];

  // add new round to list
  savedRoundJsonList.add(roundJson);

  // save list
  await prefs.setStringList('savedRounds', savedRoundJsonList);

  for (var player in players) {
    player.resetScores();
  }

  // Check if the widget is still mounted before navigating
  if (context.mounted) {
    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.initialRoute));
  }
}
