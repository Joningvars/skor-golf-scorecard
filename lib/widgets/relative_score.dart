import 'package:flutter/material.dart';
import 'package:score_card/models/player.dart';

class RelativeScoreWidget extends StatefulWidget {
  final Player player;

  const RelativeScoreWidget({
    super.key,
    required this.player,
  });

  @override
  _RelativeScoreWidgetState createState() => _RelativeScoreWidgetState();
}

class _RelativeScoreWidgetState extends State<RelativeScoreWidget> {
  @override
  Widget build(BuildContext context) {
    String displayScore = '';

    String displayText() {
      if (widget.player.relativeScore > 0) {
        displayScore = '+${widget.player.relativeScore}';
      } else if (widget.player.relativeScore < 0) {
        displayScore = '${widget.player.relativeScore}';
      } else if (widget.player.relativeScore == 0) {
        displayScore = 'E';
      }
      return displayScore;
    }

    return Text(
      displayText(),
      style: const TextStyle(
        color: Color.fromARGB(255, 24, 66, 97),
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
