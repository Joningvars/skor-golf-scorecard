import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/scorecard_screen/cell_builder.dart';

Widget buildPlayerTotalStrokes(Player player, GolfCourse course) {
  int totalStrokes = player.strokes.fold(0, (sum, stroke) => sum + stroke);
  int relativeScore = player.relativeScore;

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
  List<int> front9Strokes =
      player.strokes.take(9).where((stroke) => stroke > 0).toList();
  int totalScore9 = front9Strokes.fold(0, (sum, score) => sum + score);
  List<int> pars = holes.take(9).map((hole) => hole.par).toList();
  int relativeScore9 = totalScore9 -
      pars.take(front9Strokes.length).fold(0, (sum, par) => sum + par);

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
  List<int> back9Strokes =
      player.strokes.skip(9).where((stroke) => stroke > 0).toList();
  List<int> back9Pars = holes.skip(9).map((hole) => hole.par).toList();

  back9Strokes.fold(0, (sum, score) => sum + score);
  back9Pars.take(back9Strokes.length).fold(0, (sum, par) => sum + par);

  List<int> allNonZeroStrokes =
      player.strokes.where((stroke) => stroke > 0).toList();
  int totalStrokes = allNonZeroStrokes.fold(0, (sum, score) => sum + score);
  int totalPar = holes
      .map((hole) => hole.par)
      .take(allNonZeroStrokes.length)
      .fold(0, (sum, par) => sum + par);
  int relativeScore18 = totalStrokes - totalPar;

  return Row(
    children: [
      for (int i = 0; i < 9; i++)
        buildCell(
          player.strokes[9 + i].toString(),
          width: 50,
          isPlayerTile: true,
          score: player.strokes[9 + i],
          par: back9Pars[i],
        ),
      buildCell(
        totalStrokes.toString(),
        width: 50,
        isPlayerTile: true,
        fontSize: 30,
        relativeScore: relativeScore18,
      ),
    ],
  );
}
