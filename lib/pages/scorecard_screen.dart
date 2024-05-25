import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/models/round.dart';
import 'package:score_card/routes/app_routes.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class ScorecardScreen extends StatelessWidget {
  final List<Player> players;
  final List<Hole> holes;
  final GolfCourse course;

  const ScorecardScreen({
    super.key,
    required this.players,
    required this.holes,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    bool hasBack9Score =
        players[0].strokes.sublist(9, 18).any((stroke) => stroke != 0);
    Orientation currentOrientation = MediaQuery.of(context).orientation;

    Future<void> _saveRound(BuildContext context) async {
      int totalStrokes =
          players[0].strokes.fold(0, (sum, stroke) => sum + stroke);
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
      List<String>? savedRoundJsonList =
          prefs.getStringList('savedRounds') ?? [];

      // add new round to list
      savedRoundJsonList.add(roundJson);

      // save list
      await prefs.setStringList('savedRounds', savedRoundJsonList);

      if (context.mounted) {
        Navigator.popUntil(
            context, ModalRoute.withName(AppRoutes.initialRoute));
      }
    }

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.initialRoute,
                (route) => false,
              );
            },
            icon: const Icon(Icons.home),
          ),
          IconButton(
            onPressed: () {
              _saveRound(context);
            },
            icon: const Icon(Icons.save_alt_rounded),
          ),
        ],
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentOrientation == Orientation.landscape)
                    Text(
                      formattedDate,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    '${course.clubName} (${course.name})',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Text(
                          'ÖRN',
                          style: TextStyle(color: Colors.green, fontSize: 10),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'FUGL',
                          style: TextStyle(color: Colors.red, fontSize: 10),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'PAR',
                          style: TextStyle(
                            color: Color.fromARGB(255, 33, 109, 168),
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'SKOLLI',
                          style: TextStyle(
                              color: Colors.grey.shade300, fontSize: 10),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          '2x SKOLLI',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: Image.asset(
                'assets/images/skor_logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              theme.colorScheme.secondary,
              theme.primaryColor,
              theme.primaryColor,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (currentOrientation == Orientation.landscape) {
                // Landscape layout
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildFront9holes(),
                          _buildFront9Par(),
                          _buildFront9Length(),
                          _buildFront9Handicap(),
                          for (var player in players)
                            _buildPlayerFront9(player),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildBack9Holes(),
                          _buildBack9Par(),
                          _buildBack9Length(),
                          _buildBack9Handicap(),
                          for (var player in players) _buildPlayerBack9(player),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                // Portrait layout
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nafn:',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Högg:',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      for (var player in players)
                        Row(
                          children: [
                            Text(
                              '${player.firstName} ${player.lastName}'
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
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
                            const Spacer(),
                            _buildPlayerTotalStrokes(player),
                          ],
                        ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildFront9holes(),
                                _buildFront9Par(),
                                _buildFront9Length(),
                                _buildFront9Handicap(),
                                for (var player in players)
                                  _buildPlayerFront9(player),
                              ],
                            ),
                            if (hasBack9Score)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildBack9Holes(),
                                  _buildBack9Par(),
                                  _buildBack9Length(),
                                  _buildBack9Handicap(),
                                  for (var player in players)
                                    _buildPlayerBack9(player),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerTotalStrokes(Player player) {
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

  // FRONT 9
  Widget _buildFront9holes() {
    return Row(
      children: [
        _buildCell('Hola', width: 100),
        for (var holeNumber = 1; holeNumber <= 9; holeNumber++)
          _buildCell('$holeNumber', width: 50, isPlayerTile: false),
        _buildCell('ÚT', width: 50, isPlayerTile: false),
      ],
    );
  }

  Widget _buildFront9Length() {
    int totalLength9 =
        holes.take(9).fold(0, (prev, hole) => prev + hole.yellowTee);
    return Row(
      children: [
        _buildCell('Gulur(M)', width: 100),
        for (var i = 0; i < 9; i++)
          _buildCell('${holes[i].yellowTee}', width: 50, isPlayerTile: false),
        _buildCell('$totalLength9', width: 50, isPlayerTile: false),
      ],
    );
  }

  Widget _buildFront9Par() {
    int totalPar9 = holes.take(9).fold(0, (prev, hole) => prev + hole.par);
    return Row(
      children: [
        _buildCell('Par', width: 100),
        for (var i = 0; i < 9; i++)
          _buildCell('${holes[i].par}', width: 50, isPlayerTile: false),
        _buildCell(totalPar9.toString(), width: 50, isPlayerTile: false),
      ],
    );
  }

  Widget _buildFront9Handicap() {
    return Row(
      children: [
        _buildCell('Forgjöf', width: 100),
        for (var i = 0; i < 9; i++)
          _buildCell('${holes[i].handicap}', width: 50, isPlayerTile: false),
        _buildCell('', width: 50, isPlayerTile: false),
      ],
    );
  }

  // BACK 9
  Widget _buildBack9Holes() {
    return Row(
      children: [
        for (var holeNumber = 10; holeNumber <= 18; holeNumber++)
          _buildCell('$holeNumber', width: 50, isPlayerTile: false),
        _buildCell(''),
      ],
    );
  }

  Widget _buildBack9Length() {
    int totalLength18 = holes.fold(0, (prev, hole) => prev + hole.yellowTee);
    return Row(
      children: [
        for (var i = 9; i < 18; i++)
          _buildCell('${holes[i].yellowTee}', width: 50, isPlayerTile: false),
        _buildCell(totalLength18.toString(), width: 50, isPlayerTile: false),
      ],
    );
  }

  Widget _buildBack9Par() {
    int totalPar9 = holes.fold(0, (prev, hole) => prev + hole.par);
    return Row(
      children: [
        for (var i = 9; i < 18; i++)
          _buildCell('${holes[i].par}', width: 50, isPlayerTile: false),
        _buildCell(totalPar9.toString(), width: 50, isPlayerTile: false),
      ],
    );
  }

  Widget _buildBack9Handicap() {
    return Row(
      children: [
        for (var i = 9; i < 18; i++)
          _buildCell('${holes[i].handicap}', width: 50, isPlayerTile: false),
        _buildCell('', width: 50, isPlayerTile: false),
      ],
    );
  }

  Widget _buildPlayerFront9(Player player) {
    int totalScore9 =
        player.strokes.take(9).fold(0, (prev, score) => prev + score);
    List<int> pars = holes.take(9).map((hole) => hole.par).toList();

    return Row(
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
    );
  }

  Widget _buildPlayerBack9(Player player) {
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
          _buildCell(
            back9Scores[i].toString(),
            width: 50,
            isPlayerTile: true,
            score: back9Scores[i],
            par: back9Pars[i],
          ),
        _buildCell(
          totalScore.toString(),
          width: 50,
          isPlayerTile: true,
          fontSize: 30,
        ),
      ],
    );
  }

  Widget _buildCell(
    String text, {
    double width = 50,
    bool isPlayerTile = false,
    double fontSize = 14,
    int? score,
    int? par,
    Color tileColor = const Color(0XFF195482),
  }) {
    Color _calculateColor(int score, int par) {
      if (score == par - 2) {
        return Colors.green;
      } else if (score == par - 1) {
        return Colors.red;
      } else if (score == par) {
        return const Color.fromARGB(255, 33, 109, 168);
      } else if (score == par + 1) {
        return Colors.grey.shade300;
      } else {
        return Colors.grey;
      }
    }

    Color textColor = Colors.white;

    if (isPlayerTile && score != null && par != null) {
      tileColor = _calculateColor(score, par);

      textColor = Colors.black;
    }

    return SizedBox(
      width: width,
      height: isPlayerTile ? 38 : 38,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.05),
          color: tileColor,
        ),
        alignment: Alignment.center,
        child: FittedBox(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }
}
