import 'package:flutter/material.dart';
import 'package:flutter_icon_shadow/flutter_icon_shadow.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/hole_screen/custom_counter.dart';
import 'package:score_card/pages/round_setup_screen/player_button.dart';

class HoleDetail extends StatelessWidget {
  final Hole currentHole;
  final int currentHoleIndex;
  final int totalHoles;
  final GolfCourse course;
  final List<Player> players;
  final int selectedTee;

  const HoleDetail({
    super.key,
    required this.currentHole,
    required this.currentHoleIndex,
    required this.totalHoles,
    required this.course,
    required this.players,
    required this.selectedTee,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
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
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.04,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: screenSize.height * 0.15,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/skor_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Expanded(
                  child: OrientationBuilder(
                    builder: (context, orientation) {
                      return orientation == Orientation.landscape
                          ? SingleChildScrollView(
                              child: _buildContent(
                                  currentHole, theme, context, screenSize),
                            )
                          : _buildContent(
                              currentHole, theme, context, screenSize);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getDistanceForSelectedTee(Hole hole, int selectedTee) {
    switch (selectedTee) {
      case 0:
        return '${hole.yellowTee} m';
      case 1:
        return '${hole.redTee} m';
      case 2:
        return '${hole.whiteTee} m';
      case 3:
        return '${hole.blueTee} m';
      default:
        return '${hole.yellowTee} m';
    }
  }

  Widget _buildContent(Hole currentHole, ThemeData theme, BuildContext context,
      Size screenSize) {
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
              style: TextStyle(
                fontSize: screenSize.width * 0.4,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: const [
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width * 0.07,
                    color: const Color.fromARGB(255, 211, 221, 232),
                    shadows: const [
                      Shadow(
                        offset: Offset(3.0, 2.0),
                        blurRadius: 3.0,
                        color: Color.fromARGB(82, 7, 19, 29),
                      ),
                    ],
                  ),
                ),
                Text(
                  getDistanceForSelectedTee(currentHole, selectedTee),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width * 0.07,
                    color: const Color(0XFF3270A2),
                    shadows: const [
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
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: screenSize.width * 0.038,
                    color: Colors.grey,
                    shadows: const [
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
        Spacer(),
        const Divider(
          color: Color.fromARGB(82, 15, 39, 58),
          thickness: 4,
        ),
        if (players.isNotEmpty)
          Column(
            children: players.map((player) {
              return Column(
                children: [
                  SizedBox(height: screenSize.height * 0.01),
                  Row(
                    children: [
                      PlayerButton(
                        player: player,
                        onDelete: () {},
                        onEdit: () {},
                      ),
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
        Icon(
          Icons.swipe,
          color: const Color.fromARGB(255, 27, 91, 141),
          size: screenSize.width * 0.1,
        ),
      ],
    );
  }
}
