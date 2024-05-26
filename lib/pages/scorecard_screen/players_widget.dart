import 'package:flutter/material.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/scorecard_screen/cell_builder.dart';

Widget buildPlayerTotalStrokes(Player player) {
  int totalStrokes = player.strokes.fold(0, (sum, stroke) => sum + stroke);

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
                color: Colors.black,
              ),
              Shadow(
                blurRadius: 30,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget buildPlayerFront9(Player player, List<Hole> holes) {
  int totalScore9 =
      player.strokes.take(9).fold(0, (prev, score) => prev + score);
  List<int> pars = holes.take(9).map((hole) => hole.par).toList();

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
      ),
    ],
  );
}

Widget buildPlayerBack9(Player player, List<Hole> holes) {
  if (player.strokes.length < 18) {
    //error handle if not enough strokes
    return const SizedBox();
  }

  List<int> back9Scores = player.strokes.skip(9).toList();
  int totalScore = player.strokes.reduce((sum, score) => sum + score);

  List<int> back9Pars = holes.skip(9).map((hole) => hole.par).toList();

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
        totalScore.toString(),
        width: 50,
        isPlayerTile: true,
        fontSize: 30,
      ),
    ],
  );
}
