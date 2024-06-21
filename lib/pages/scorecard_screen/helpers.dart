import 'package:flutter/material.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/pages/scorecard_screen/cell_builder.dart';

Widget buildFront9holes(List<Hole> holes) {
  return Row(
    children: [
      for (var holeNumber = 1; holeNumber <= 9; holeNumber++)
        buildCell('$holeNumber', width: 50, isPlayerTile: false),
      buildCell('ÚT', width: 50, isPlayerTile: false),
    ],
  );
}

Widget buildFront9Length(List<Hole> holes) {
  int totalLength9 =
      holes.take(9).fold(0, (prev, hole) => prev + hole.yellowTee);
  return Row(
    children: [
      for (var i = 0; i < 9; i++)
        buildCell('${holes[i].yellowTee}', width: 50, isPlayerTile: false),
      buildCell('$totalLength9', width: 50, isPlayerTile: false),
    ],
  );
}

Widget buildFront9Par(List<Hole> holes) {
  int totalPar9 = holes.take(9).fold(0, (prev, hole) => prev + hole.par);
  return Row(
    children: [
      for (var i = 0; i < 9; i++)
        buildCell('${holes[i].par}', width: 50, isPlayerTile: false),
      buildCell(totalPar9.toString(), width: 50, isPlayerTile: false),
    ],
  );
}

Widget buildFront9Handicap(List<Hole> holes) {
  return Row(
    children: [
      for (var i = 0; i < 9; i++)
        buildCell('${holes[i].handicap}', width: 50, isPlayerTile: false),
      buildCell('', width: 50, isPlayerTile: false),
    ],
  );
}

Widget buildBack9Holes(List<Hole> holes) {
  return Row(
    children: [
      for (var holeNumber = 10; holeNumber <= 18; holeNumber++)
        buildCell('$holeNumber', width: 50, isPlayerTile: false),
      buildCell('ÚT', width: 50, isPlayerTile: false),
    ],
  );
}

Widget buildBack9Length(List<Hole> holes) {
  int totalLength18 = holes.fold(0, (prev, hole) => prev + hole.yellowTee);
  return Row(
    children: [
      for (var i = 9; i < 18; i++)
        buildCell('${holes[i].yellowTee}', width: 50, isPlayerTile: false),
      buildCell(totalLength18.toString(), width: 50, isPlayerTile: false),
    ],
  );
}

Widget buildBack9Par(List<Hole> holes) {
  int totalPar9 = holes.fold(0, (prev, hole) => prev + hole.par);
  return Row(
    children: [
      for (var i = 9; i < 18; i++)
        buildCell('${holes[i].par}', width: 50, isPlayerTile: false),
      buildCell(totalPar9.toString(), width: 50, isPlayerTile: false),
    ],
  );
}

Widget buildBack9Handicap(List<Hole> holes) {
  return Row(
    children: [
      for (var i = 9; i < 18; i++)
        buildCell('${holes[i].handicap}', width: 50, isPlayerTile: false),
      buildCell('', width: 50, isPlayerTile: false),
    ],
  );
}
