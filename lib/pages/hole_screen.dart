// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icon_shadow/flutter_icon_shadow.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/round_setup_screen.dart';
import 'package:score_card/pages/scorecard_screen.dart';
import 'package:score_card/widgets/relative_score.dart';

class HoleDetailPage extends StatefulWidget {
  final List<Hole> holes;
  final int selectedTee;
  final List<Player> players;
  final GolfCourse course;

  const HoleDetailPage({
    super.key,
    required this.holes,
    required this.course,
    required this.selectedTee,
    required this.players,
  });

  @override
  _HoleDetailPageState createState() => _HoleDetailPageState();
}

class _HoleDetailPageState extends State<HoleDetailPage> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.holes.length + 1,
        itemBuilder: (context, index) {
          if (index < widget.holes.length) {
            return HoleDetail(
              currentHole: widget.holes[index],
              currentHoleIndex: index,
              totalHoles: widget.holes.length,
              course: widget.course,
              players: widget.players,
            );
          } else {
            return ScorecardScreen(
              players: widget.players,
              holes: widget.holes,
              course: widget.course,
            );
          }
        },
      ),
    );
  }
}

class HoleDetail extends StatelessWidget {
  final Hole currentHole;
  final int currentHoleIndex;
  final int totalHoles;
  final GolfCourse course;
  final List<Player> players;

  const HoleDetail({
    super.key,
    required this.currentHole,
    required this.currentHoleIndex,
    required this.totalHoles,
    required this.course,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
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
                    child: _buildContent(currentHole, theme, context),
                  )
                : _buildContent(currentHole, theme, context);
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      Hole currentHole, ThemeData theme, BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 130,
            child: Image.asset(
              'assets/images/skor_logo.png',
            )),
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
        const SizedBox(height: 50),
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
                    children: [
                      Row(
                        children: [
                          PlayerButton(
                            player: player,
                            onDelete: () {},
                            onEdit: () {},
                          ),
                          // RelativeScoreWidget(player: player),
                        ],
                      ),
                      // const Spacer(),
                      CustomCounter(
                        player: player,
                        holeIndex: currentHoleIndex,
                        holes: course.holes,
                      ),
                    ],
                  ),
                ],
              );
            }).toList(),
          ),
        const Icon(
          Icons.swipe,
          color: Color.fromARGB(255, 27, 91, 141),
          size: 40,
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
    if (strokeCount > 0) {
      showCounter = true;
    }
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

  Color _getBackgroundColor() {
    int score = widget.player.strokes[widget.holeIndex];
    int par = widget.holes[widget.holeIndex].par;
    int relativeScore = score - par;

    if (relativeScore < -2) {
      return Colors.orange.shade400;
    } else if (relativeScore == -2) {
      return Colors.green.shade400;
    } else if (relativeScore == -1) {
      return Colors.red.shade400;
    } else if (relativeScore == 0) {
      return const Color(0XFF3270A2);
    } else if (relativeScore == 1) {
      return Colors.grey;
    } else if (relativeScore == 2) {
      return Colors.grey.shade700;
    } else if (relativeScore > 2) {
      return Colors.grey.shade900;
    } else {
      return const Color(0XFF3270A2);
    }
  }

  void _showCounter() {
    HapticFeedback.selectionClick();
    setState(() {
      showCounter = true;
      strokeCount = widget.holes[widget.holeIndex].par;
      widget.player.strokes[widget.holeIndex] = strokeCount;
      _updateStrokeCount(0, widget.player);
    });
  }

  @override
  Widget build(BuildContext context) {
    return showCounter
        ? Expanded(
            child: Row(
              children: [
                RelativeScoreWidget(player: widget.player),
                const Spacer(),
                SizedBox(
                  height: 65,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: _getBackgroundColor(),
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
                ),
              ],
            ),
          )
        : Expanded(
            child: Row(
              children: [
                RelativeScoreWidget(player: widget.player),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white, size: 35),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showCounter();
                  },
                ),
              ],
            ),
          );
  }
}
