import 'package:flutter/material.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/scorecard_screen/helpers.dart';
import 'package:score_card/pages/scorecard_screen/players_widget.dart';

class Front9Widget extends StatelessWidget {
  final List<Player> players;
  final List<Hole> holes;

  const Front9Widget({
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
        buildFront9holes(holes),
        buildFront9Par(holes),
        buildFront9Length(holes),
        buildFront9Handicap(holes),
        for (var player in players) buildPlayerFront9(player, holes),
      ],
    );
  }
}
