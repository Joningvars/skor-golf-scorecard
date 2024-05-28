import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/scorecard_screen/cell_builder.dart';

Widget buildPlayerTotalStrokes(Player player, GolfCourse course) {
  int totalStrokes = player.strokes.fold(0, (sum, stroke) => sum + stroke);
  int totalPar = course.holes.fold(0, (sum, hole) => sum + hole.par);
  int relativeScore = totalStrokes - totalPar;

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      children: [
        Text(
          '$totalStrokes',
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 10,
                color: Colors.black26,
              ),
              Shadow(
                blurRadius: 10,
                color: Colors.black12,
              ),
            ],
          ),
        ),
        Column(
          children: [
            Text(
              relativeScore > 0
                  ? '+$relativeScore'
                  : (relativeScore == 0 ? 'E' : '$relativeScore'),
              style: const TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ],
    ),
  );
}

Widget buildPlayerFront9(Player player, List<Hole> holes) {
  int totalScore9 =
      player.strokes.take(9).fold(0, (prev, score) => prev + score);
  List<int> pars = holes.take(9).map((hole) => hole.par).toList();
  int totalPar9 = pars.fold(0, (sum, par) => sum + par);
  int relativeScore9 = totalScore9 - totalPar9;

  return Row(
    children: [
      buildCell(
        player.initials,
        width: 100,
        isPlayerTile: true,
      ),
      for (var i = 0; i < 9; i++)
        buildCell(
          player.strokes[i].toString(),
          width: 50,
          isPlayerTile: true,
          score: player.strokes[i],
          par: pars[i],
        ),
      buildCell(
        totalScore9.toString(),
        width: 50,
        isPlayerTile: true,
        fontSize: 30,
        relativeScore: relativeScore9,
      ),
    ],
  );
}

Widget buildPlayerBack9(Player player, List<Hole> holes, GolfCourse course) {
  if (player.strokes.length < 18) {
    return const SizedBox();
  }

  List<int> back9Scores = player.strokes.skip(9).toList();
  int totalScoreBack9 = back9Scores.fold(0, (sum, score) => sum + score);
  List<int> back9Pars = holes.skip(9).map((hole) => hole.par).toList();
  int totalParBack9 = back9Pars.fold(0, (sum, par) => sum + par);
  // ignore: unused_local_variable
  int relativeScoreBack9 = totalScoreBack9 - totalParBack9;

  int totalScore18 = player.strokes.fold(0, (sum, score) => sum + score);
  int totalPar18 = course.holes.fold(0, (sum, hole) => sum + hole.par);
  int relativeScore18 = totalScore18 - totalPar18;

  return Row(
    children: [
      for (int i = 0; i < back9Scores.length; i++)
        buildCell(
          back9Scores[i].toString(),
          width: 50,
          isPlayerTile: true,
          score: back9Scores[i],
          par: back9Pars[i],
        ),
      buildCell(
        totalScore18.toString(),
        width: 50,
        isPlayerTile: true,
        fontSize: 30,
        relativeScore: relativeScore18,
      ),
    ],
  );
}
