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
            if (course.par != 0)
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
  int validHoleCount = holes.length < 9 ? holes.length : 9;
  List<int> front9Strokes = player.strokes.take(validHoleCount).toList();
  List<int> pars = holes.take(validHoleCount).map((hole) => hole.par).toList();
  int totalScore9 = front9Strokes.fold(0, (sum, score) => sum + score);
  int relativeScore9 = player.calculateRelativeScoreFront9(holes);

  return Row(
    children: [
      for (var i = 0; i < validHoleCount; i++)
        buildCell(
          player.strokes.length > i ? player.strokes[i].toString() : '0',
          width: 50,
          isPlayerTile: true,
          score: player.strokes.length > i ? player.strokes[i] : 0,
          par: pars[i],
        ),
      buildCell(
        totalScore9.toString(),
        width: 50,
        isPlayerTile: true,
        fontSize: 30,
        relativeScore: holes[0].par == 0 ? 0 : relativeScore9,
      ),
    ],
  );
}

Widget buildPlayerBack9(Player player, List<Hole> holes, GolfCourse course) {
  int validHoleCount = holes.length < 18 ? holes.length - 9 : 9;
  List<int> total18strokes = player.strokes.isNotEmpty
      ? player.strokes.sublist(0, 9 + validHoleCount).toList()
      : List<int>.filled(validHoleCount, 0);
  List<int> pars = holes.length > 9
      ? holes.sublist(9, 9 + validHoleCount).map((hole) => hole.par).toList()
      : List<int>.filled(validHoleCount, 0);
  int totalScore18 = total18strokes.fold(0, (sum, score) => sum + score);
  int relativeScore18 = player.relativeScore;

  //back 9 stats
  int relativeScoreBack9 = player.calculateRelativeScoreBack9(holes);
  List<int> back9Strokes = player.strokes.sublist(validHoleCount).toList();
  int totalScoreBack9 = back9Strokes.fold(0, (sum, score) => sum + score);
  //front 9 stats
  List<int> front9Strokes = player.strokes.take(validHoleCount).toList();
  int totalScoreFront9 = front9Strokes.fold(0, (sum, score) => sum + score);
  int relativeScoreFront9 = player.calculateRelativeScoreFront9(holes);

  return Row(
    children: [
      for (int i = 0; i < validHoleCount; i++)
        buildCell(
          player.strokes.length > (9 + i)
              ? player.strokes[9 + i].toString()
              : '0',
          width: 50,
          isPlayerTile: true,
          score: player.strokes.length > (9 + i) ? player.strokes[9 + i] : 0,
          par: pars[i],
        ),
      buildCell(
        totalScoreFront9.toString(),
        width: 50,
        isPlayerTile: true,
        fontSize: 30,
        relativeScore: course.par > 0 ? relativeScoreFront9 : 0,
      ),
      buildCell(
        totalScoreBack9.toString(),
        width: 50,
        isPlayerTile: true,
        fontSize: 30,
        relativeScore: course.par > 0 ? relativeScoreBack9 : 0,
      ),
      buildCell(
        totalScore18.toString(),
        width: 50,
        isPlayerTile: true,
        fontSize: 30,
        relativeScore: course.par > 0 ? relativeScore18 : 0,
      ),
    ],
  );
}
