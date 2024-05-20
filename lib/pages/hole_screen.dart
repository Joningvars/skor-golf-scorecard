import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/round_setup_screen.dart';
import 'package:score_card/pages/scorecard_screen.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:score_card/widgets/customAppBar.dart';

class HoleDetailPage extends StatelessWidget {
  final List<Hole> holes;
  final int selectedTee;
  final List<Player> players;
  int currentHoleIndex;
  final GolfCourse course;

  HoleDetailPage({
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

  void _onItemTapped(int index, BuildContext context) {
    if (index == 0) {
      _navigateToPrevHole(context);
    } else if (index == 1) {
      _navigateToNextHole(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Hole currentHole = holes[currentHoleIndex];

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: CustomAppBar(
        title: '',
        action: IconButton(
          icon: const Icon(
            Icons.arrow_forward_ios,
            color: Color(0XFF3270A2),
          ),
          onPressed: () => _navigateToNextHole(context),
        ),
        leadAction: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Color(0XFF3270A2),
          ),
          onPressed: () => _navigateToPrevHole(context),
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
              ]),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ' ${currentHole.number}',
                    style: const TextStyle(
                      fontSize: 100,
                      color: Color.fromARGB(255, 198, 208, 219),
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: Offset(3.0, 2.0),
                          blurRadius: 5.0,
                          color: Color.fromARGB(82, 7, 19, 29),
                        ),
                      ],
                    ),
                  ),
                  const Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Icon(
                        Icons.golf_course,
                        size: 50,
                        color: Color.fromARGB(255, 31, 95, 147),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        'Par ${currentHole.par}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color.fromARGB(255, 198, 208, 219),
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
                          color: Color.fromARGB(255, 198, 208, 219),
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
                          fontSize: 10,
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
              SizedBox(height: 120),

              //setja mynd herna
              Divider(
                color: theme.colorScheme.secondary.withOpacity(0.3),
                thickness: 2,
              ),

              if (players.isNotEmpty)
                Column(
                  children: [
                    for (int i = 0; i < players.length; i++)
                      Column(
                        children: [
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PlayerButton(
                                player: players[i],
                                onDelete: () {},
                                onEdit: () {},
                              ),
                              Spacer(),
                              CustomCounter(
                                player: players[i],
                                holeIndex: currentHoleIndex,
                                holes: holes,
                              ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomCounter extends StatefulWidget {
  final Player player;
  final int holeIndex;
  final List<Hole> holes;

  CustomCounter({
    Key? key,
    required this.player,
    required this.holeIndex,
    required this.holes,
  }) : super(key: key);

  @override
  State<CustomCounter> createState() => _CustomCounterState();
}

class _CustomCounterState extends State<CustomCounter> {
  late int strokeCount;
  bool scoreDocumented = false;

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

  void _updateStrokeCount(int change) {
    setState(() {
      strokeCount += change;
      if (strokeCount < 1) {
        strokeCount = 1;
      } else if (strokeCount > 10) {
        strokeCount = 10;
      }

      if (widget.player.strokes.length > widget.holeIndex) {
        widget.player.strokes[widget.holeIndex] = strokeCount;
      } else {
        widget.player.strokes.addAll(List.filled(
          widget.holeIndex - widget.player.strokes.length,
          widget.holes[widget.holeIndex].par,
        ));
        widget.player.strokes.add(strokeCount);
      }
    });
  }

  String _displayScoreText() {
    int score = widget.player.strokes[widget.holeIndex];
    int par = widget.holes[widget.holeIndex].par - 1;
    int relativeScore = score - par;
    String scoreText = '';

    if (widget.holeIndex >= 0 && widget.holeIndex < widget.holes.length) {
      switch (relativeScore) {
        case -2:
          scoreText = 'ALBATROSS';
          break;
        case -1:
          scoreText = 'ÖRN';
          break;
        case 0:
          scoreText = 'FUGL';
          break;
        case 1:
          scoreText = 'PAR';
          break;
        case 2:
          scoreText = 'SKOLLI';
          break;
        case 3:
          scoreText = '2X SKOLLI';
          break;
        case 4:
          scoreText = '3X SKOLLI';
          break;
        default:
          if (relativeScore < -2) {
            scoreText = 'ÁS';
          } else {
            scoreText = 'ANNAÐ';
          }
      }
    }

    return scoreText;
  }

  void _documentScore() {
    setState(() {
      scoreDocumented = true;
      strokeCount = widget.holes[widget.holeIndex].par;
      widget.player.strokes[widget.holeIndex] = strokeCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          border:
              Border.all(color: theme.colorScheme.secondary.withOpacity(0.7)),
          borderRadius: BorderRadius.circular(8),
          color: const Color(0XFF3270A2),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                if (scoreDocumented)
                  InkWell(
                    onTap: () {
                      _updateStrokeCount(-1);
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
                    color: Colors.white,
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
                if (scoreDocumented)
                  InkWell(
                    onTap: () {
                      _updateStrokeCount(1);
                    },
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
                if (!scoreDocumented)
                  InkWell(
                    onTap: _documentScore,
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 35,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
          ],
        ),
      ),
    );
  }
}
