import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icon_shadow/flutter_icon_shadow.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/round_setup_screen.dart';
import 'package:score_card/pages/scorecard_screen.dart';
import 'package:score_card/widgets/customAppBar.dart';
import 'package:score_card/widgets/relative_score.dart';

class HoleDetailPage extends StatelessWidget {
  final List<Hole> holes;
  final int selectedTee;
  final List<Player> players;
  final int currentHoleIndex;
  final GolfCourse course;

  const HoleDetailPage({
    super.key,
    required this.holes,
    required this.course,
    required this.selectedTee,
    required this.players,
    this.currentHoleIndex = 0,
  });

  void _navigateToNextHole(BuildContext context) {
    if (currentHoleIndex < holes.length - 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HoleDetailPage(
            course: course,
            holes: holes,
            selectedTee: selectedTee,
            players: players,
            currentHoleIndex: currentHoleIndex + 1,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScorecardScreen(
            course: course,
            players: players,
            holes: holes,
          ),
        ),
      );
    }
  }

  void _navigateToPrevHole(BuildContext context) {
    if (currentHoleIndex > 0) {
      Navigator.pop(context);
    } else {
      Navigator.pop(context); // pops if no previous hole
    }
  }

  @override
  Widget build(BuildContext context) {
    Hole currentHole = holes[currentHoleIndex];
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CustomAppBar(
        title: '',
        action: IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios,
          ),
          onPressed: () {
            HapticFeedback.selectionClick();
            _navigateToNextHole(context);
          },
        ),
        leadAction: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            HapticFeedback.selectionClick();
            _navigateToPrevHole(context);
          },
        ),
      ),
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: OrientationBuilder(
            builder: (context, orientation) {
              return orientation == Orientation.landscape
                  ? SingleChildScrollView(
                      child: _buildContent(currentHole, theme),
                    )
                  : _buildContent(currentHole, theme);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Hole currentHole, ThemeData theme) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Stack(children: [
              Positioned(
                top: 4,
                left: 4,
                right: 0,
                bottom: 0,
                child: SizedBox(
                  width: 40,
                  child: IconShadow(
                    Icon(
                      Icons.golf_course_rounded,
                      color: Color.fromARGB(121, 12, 32, 48),
                      size: 90,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 40,
                child: Icon(
                  Icons.golf_course_rounded,
                  color: Color(0XFF195482),
                  size: 90,
                ),
              ),
            ]),
            Text(
              ' ${currentHole.number}',
              style: const TextStyle(
                fontSize: 146,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(8.0, 8.0),
                    blurRadius: 0,
                    color: Color.fromARGB(82, 7, 19, 29),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Par ${currentHole.par}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color.fromARGB(255, 211, 221, 232),
                    shadows: [
                      Shadow(
                        offset: Offset(3.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(82, 7, 19, 29),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${currentHole.yellowTee} m',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Color(0XFF3270A2),
                    shadows: [
                      Shadow(
                        offset: Offset(3.0, 2.0),
                        blurRadius: 5.0,
                        color: Color.fromARGB(82, 7, 19, 29),
                      ),
                    ],
                  ),
                ),
                Text(
                  'FGJ ${currentHole.handicap}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey,
                    shadows: [
                      Shadow(
                        offset: Offset(3.0, 2.0),
                        blurRadius: 5.0,
                        color: Color.fromARGB(82, 15, 39, 58),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 100),
        const Divider(
          color: Color.fromARGB(82, 15, 39, 58),
          thickness: 4,
        ),
        if (players.isNotEmpty)
          Column(
            children: players.map((player) {
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          PlayerButton(
                            player: player,
                            onDelete: () {},
                            onEdit: () {},
                          ),
                          Positioned(
                            top: 10,
                            left: 48,
                            right: 0,
                            bottom: 0,
                            child: RelativeScoreWidget(player: player),
                          ),
                        ],
                      ),
                      const Spacer(),
                      CustomCounter(
                        player: player,
                        holeIndex: currentHoleIndex,
                        holes: holes,
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
      ],
    );
  }
}

class CustomCounter extends StatefulWidget {
  final Player player;
  final int holeIndex;
  final List<Hole> holes;

  const CustomCounter({
    super.key,
    required this.player,
    required this.holeIndex,
    required this.holes,
  });

  @override
  State<CustomCounter> createState() => _CustomCounterState();
}

class _CustomCounterState extends State<CustomCounter> {
  late int strokeCount;
  bool showCounter = false;

  @override
  void initState() {
    super.initState();
    if (widget.player.strokes.length <= widget.holeIndex) {
      widget.player.strokes.addAll(
        List<int>.filled(
          widget.holeIndex - widget.player.strokes.length + 1,
          0,
        ),
      );
    }
    strokeCount = widget.player.strokes[widget.holeIndex];
  }

  void _updateStrokeCount(int change, Player player) {
    HapticFeedback.lightImpact();
    setState(() {
      strokeCount += change;
      if (strokeCount < 1) {
        strokeCount = 1;
      } else if (strokeCount > 10) {
        strokeCount = 10;
      }

      int score = strokeCount;
      int par = widget.holes[widget.holeIndex].par;
      int relativeScore = score - par;

      player.relativeScore -= player.strokes[widget.holeIndex] - par;

      player.strokes[widget.holeIndex] = strokeCount;
      player.relativeScore += relativeScore;
    });
  }

  String _displayScoreText() {
    int score = widget.player.strokes[widget.holeIndex];
    int par = widget.holes[widget.holeIndex].par;
    int relativeScore = score - par;
    String scoreText = '';

    if (widget.holeIndex >= 0 && widget.holeIndex < widget.holes.length) {
      switch (relativeScore) {
        case -3:
          scoreText = 'ALBATROSS';
          break;
        case -2:
          scoreText = 'ÖRN';
          break;
        case -1:
          scoreText = 'FUGL';
          break;
        case 0:
          scoreText = 'PAR';
          break;
        case 1:
          scoreText = 'SKOLLI';
          break;
        case 2:
          scoreText = '2X SKOLLI';
          break;
        case 3:
          scoreText = '3X SKOLLI';
          break;
        default:
          if (relativeScore < -3) {
            scoreText = 'ÁS';
          } else {
            scoreText = 'ANNAÐ';
          }
      }
    }

    return scoreText;
  }

  void _showCounter() {
    HapticFeedback.selectionClick();
    setState(() {
      showCounter = true;
      strokeCount = widget.holes[widget.holeIndex].par;
      widget.player.strokes[widget.holeIndex] = strokeCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showCounter
        ? SizedBox(
            height: 65,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0XFF3270A2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: const Offset(3, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      _updateStrokeCount(-1, widget.player);
                    },
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.grey.shade200,
                    ),
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              textAlign: TextAlign.center,
                              _displayScoreText(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 8,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Text(
                              textAlign: TextAlign.center,
                              strokeCount.toString(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      _updateStrokeCount(1, widget.player);
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
          )
        : IconButton(
            icon: const Icon(Icons.add, color: Colors.white, size: 35),
            onPressed: () {
              HapticFeedback.lightImpact();
              _showCounter();
            },
          );
  }
}
