import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/scorecard_screen/helpers.dart';
import 'package:score_card/pages/scorecard_screen/players_widget.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    super.key,
    required this.holes,
    required this.players,
    required this.hasBack9Score,
    required this.course,
  });

  final List<Hole> holes;
  final List<Player> players;
  final bool hasBack9Score;
  final GolfCourse course;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFront9holes(holes),
            buildFront9Par(holes),
            buildFront9Length(holes),
            buildFront9Handicap(holes),
            for (var player in players) buildPlayerFront9(player, holes),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildBack9Holes(holes),
            buildBack9Par(holes),
            buildBack9Length(holes),
            buildBack9Handicap(holes),
            for (var player in players) buildPlayerBack9(player, holes, course),
          ],
        ),
      ],
    );
  }
}
