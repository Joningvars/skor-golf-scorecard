import 'package:flutter/material.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/theme/theme_helper.dart';

class RelativeScoreWidget extends StatefulWidget {
  final Player player;

  RelativeScoreWidget({
    Key? key,
    required this.player,
  }) : super(key: key);

  @override
  _RelativeScoreWidgetState createState() => _RelativeScoreWidgetState();
}

class _RelativeScoreWidgetState extends State<RelativeScoreWidget> {
  @override
  Widget build(BuildContext context) {
    String displayScore = '';

    String displayText() {
      if (widget.player.relativeScore > 0)
        displayScore = '+${widget.player.relativeScore}';
      else if (widget.player.relativeScore < 0)
        displayScore = '${widget.player.relativeScore}';
      else if (widget.player.relativeScore == 0) {
        displayScore = 'E';
      }
      return displayScore;
    }

    return Text(
      displayText(),
      style: const TextStyle(
        color: Color.fromARGB(255, 24, 66, 97),
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
