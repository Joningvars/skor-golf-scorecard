import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/theme/theme_helper.dart';

class ScorecardScreen extends StatelessWidget {
  final List<Player> players;
  final List<Hole> holes;
  final GolfCourse course;

  ScorecardScreen(
      {required this.players, required this.holes, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Row(
          children: [
            Column(
              children: [
                // Text('${course.clubName}(${course.name})',
                //     style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
            SizedBox(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Image.asset('assets/images/skor_logo.png'),
                )),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
      ),
    );
  }

  // RONT 9
  Widget _buildFront9holes() {
    return Container(
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

  // BACK 9
  Widget _buildBack9Holes() {
    return Container(
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
    int totalLength18 = holes.fold(0, (prev, hole) => prev + hole.yellowTee);
    return Container(
      child: Row(
        children: [
          for (var i = 9; i < 18; i++)
            _buildCell('${holes[i].yellowTee}', width: 50, isPlayerTile: false),
          _buildCell(totalLength18.toString(), width: 50, isPlayerTile: false),
        ],
      ),
    );
  }

  Widget _buildBack9Par() {
    int totalPar9 = holes.fold(0, (prev, hole) => prev + hole.par);
    return Container(
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
    List<int> pars = holes.take(9).map((hole) => hole.par).toList();

    return Container(
      child: Row(
        children: [
          _buildCell(
            player.initials,
            width: 100,
          ),
          for (var i = 0; i < 9; i++)
            _buildCell(
              player.strokes[i].toString(),
              width: 50,
              isPlayerTile: true,
              score: player.strokes[i],
              par: pars[i],
            ),
          _buildCell(
            totalScore9.toString(),
            width: 50,
            isPlayerTile: true,
            fontSize: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerBack9(Player player) {
    List<int> back9Scores = player.strokes.skip(9).toList();
    int totalScore9 = back9Scores.fold(0, (prev, score) => prev + score);

    List<int> back9Pars = holes.skip(9).map((hole) => hole.par).toList();

    return Container(
      child: Row(
        children: [
          for (int i = 0; i < back9Scores.length; i++)
            _buildCell(
              back9Scores[i].toString(),
              width: 50,
              isPlayerTile: true,
              score: back9Scores[i],
              par: back9Pars[i],
            ),
          _buildCell(
            totalScore9.toString(),
            width: 50,
            isPlayerTile: true,
            fontSize: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildCell(String text,
      {double width = 50,
      bool isPlayerTile = false,
      double fontSize = 14,
      int? score,
      int? par,
      Color tileColor = const Color(0XFF195482)}) {
    if (isPlayerTile && score != null && par != null) {
      tileColor = _calculateColor(score, par);
    }

    return SizedBox(
      width: width,
      height: isPlayerTile ? 38 : 38,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.05),
            color: tileColor),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isPlayerTile ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Color _calculateColor(int score, int par) {
    if (score == par - 2) {
      return Colors.green;
    } else if (score == par - 1) {
      return Colors.red;
    } else if (score == par) {
      return const Color.fromARGB(255, 33, 109, 168);
    } else if (score == par + 1) {
      return Colors.grey.shade100;
    } else {
      return Colors.grey;
    }
  }
}
