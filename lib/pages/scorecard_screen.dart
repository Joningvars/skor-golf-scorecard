import 'package:flutter/material.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';

class ScorecardScreen extends StatelessWidget {
  final List<Player> players;
  final List<Hole> holes;

  ScorecardScreen({required this.players, required this.holes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skorkort'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // FRONT 9
                _buildFront9holes(),
                _buildFront9Par(),
                _buildFront9Length(),
                _buildFront9Handicap(),
                for (var player in players) _buildPlayerFront9(player),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BACK 9
                _buildBack9Holes(),
                _buildBack9Par(),
                _buildBack9Length(),
                _buildBack9Handicap(),
                for (var player in players) _buildPlayerBack9(player),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Front 9 Widgets
  Widget _buildFront9holes() {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildCell('Hola', width: 100),
          for (var holeNumber = 1; holeNumber <= 9; holeNumber++)
            _buildCell('$holeNumber', width: 50, isPlayerTile: false),
          _buildCell('ÚT', width: 50, isPlayerTile: false),
        ],
      ),
    );
  }

  Widget _buildFront9Length() {
    int totalLength9 =
        holes.take(9).fold(0, (prev, hole) => prev + hole.yellowTee);
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildCell('Gulur(M)', width: 100),
          for (var i = 0; i < 9; i++)
            _buildCell('${holes[i].yellowTee}', width: 50, isPlayerTile: false),
          _buildCell('${totalLength9}', width: 50, isPlayerTile: false),
        ],
      ),
    );
  }

  Widget _buildFront9Par() {
    int totalPar9 = holes.take(9).fold(0, (prev, hole) => prev + hole.par);
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildCell('Par', width: 100),
          for (var i = 0; i < 9; i++)
            _buildCell('${holes[i].par}', width: 50, isPlayerTile: false),
          _buildCell(totalPar9.toString(), width: 50, isPlayerTile: false),
        ],
      ),
    );
  }

  Widget _buildFront9Handicap() {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildCell('Forgjöf', width: 100),
          for (var i = 0; i < 9; i++)
            _buildCell('${holes[i].handicap}', width: 50, isPlayerTile: false),
          _buildCell('', width: 50, isPlayerTile: false),
        ],
      ),
    );
  }

  // Back 9 Widgets
  Widget _buildBack9Holes() {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          for (var holeNumber = 10; holeNumber <= 18; holeNumber++)
            _buildCell('$holeNumber', width: 50, isPlayerTile: false),
          _buildCell(''),
        ],
      ),
    );
  }

  Widget _buildBack9Length() {
    int totalLength9 =
        holes.skip(9).fold(0, (prev, hole) => prev + hole.yellowTee);
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          for (var i = 9; i < 18; i++)
            _buildCell('${holes[i].yellowTee}', width: 50, isPlayerTile: false),
          _buildCell('${totalLength9}', width: 50, isPlayerTile: false),
        ],
      ),
    );
  }

  Widget _buildBack9Par() {
    int totalPar9 = holes.skip(9).fold(0, (prev, hole) => prev + hole.par);
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          for (var i = 9; i < 18; i++)
            _buildCell('${holes[i].par}', width: 50, isPlayerTile: false),
          _buildCell(totalPar9.toString(), width: 50, isPlayerTile: false),
        ],
      ),
    );
  }

  Widget _buildBack9Handicap() {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          for (var i = 9; i < 18; i++)
            _buildCell('${holes[i].handicap}', width: 50, isPlayerTile: false),
          _buildCell('', width: 50, isPlayerTile: false),
        ],
      ),
    );
  }

  Widget _buildPlayerFront9(Player player) {
    int totalScore9 =
        player.strokes.take(9).fold(0, (prev, score) => prev + score);

    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildCell(player.initials, width: 100),
          for (var score in player.strokes.take(9))
            _buildCell(score.toString(), width: 50, isPlayerTile: true),
          _buildCell(
            totalScore9.toString(),
            width: 50,
            isPlayerTile: true,
            fontSize: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerBack9(Player player) {
    int totalScore9 =
        player.strokes.skip(9).fold(0, (prev, score) => prev + score);

    return Container(
      color: Colors.grey[100],
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          for (var score in player.strokes.skip(9))
            _buildCell(score.toString(), width: 50, isPlayerTile: true),
          _buildCell(
            totalScore9.toString(),
            width: 50,
            isPlayerTile: true,
            fontSize: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String text,
      {double width = 70, bool isPlayerTile = false, double fontSize = 14}) {
    return SizedBox(
      width: width,
      height: isPlayerTile ? 40 : 17,
      child: Container(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
