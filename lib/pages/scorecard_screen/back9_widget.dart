import 'package:flutter/material.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/scorecard_screen/helpers.dart';
import 'package:score_card/pages/scorecard_screen/players_widget.dart';

class Back9Widget extends StatelessWidget {
  final List<Player> players;
  final List<Hole> holes;

  const Back9Widget({
    super.key,
    required this.players,
    required this.holes,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        buildBack9Holes(holes),
        buildBack9Par(holes),
        buildBack9Length(holes),
        buildBack9Handicap(holes),
        for (var player in players) buildPlayerBack9(player, holes),
      ],
    );
  }
}
