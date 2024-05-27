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

  Widget _buildContent(
      Hole currentHole, ThemeData theme, BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 100),
            SizedBox(
              height: 130,
              child: Image.asset(
                'assets/images/skor_logo.png',
              ),
            ),
          ],
        ),
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
                  getDistanceForSelectedTee(currentHole, selectedTee),
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
                        ],
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
        const Icon(
          Icons.swipe,
          color: Color.fromARGB(255, 27, 91, 141),
          size: 40,
        ),
      ],
    );
  }
}
