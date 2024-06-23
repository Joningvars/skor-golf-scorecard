import 'package:flutter/material.dart';
import 'package:score_card/theme/theme_helper.dart';

Widget buildCell(
  String text, {
  double width = 50,
  bool isPlayerTile = false,
  double fontSize = 14,
  int? score,
  int? par,
  Color tileColor = Colors.transparent,
  int? relativeScore,
}) {
  //returns color depending on relative score else returns white
  Color getScoreColor(int score, int par) {
    final colorMap = {
      par - 2: Colors.green,
      par - 1: Colors.red,
      par: const Color.fromARGB(255, 33, 109, 168),
      par + 1: Colors.grey.shade300,
      par + 2: Colors.grey.shade500,
    };

    if (par == 0) {
      return Colors.white;
    }

    if (score == par - 3 && score != 0) {
      return Colors.orange;
    }

    return colorMap[score] ??
        (score > par + 2 ? Colors.grey.shade800 : Colors.white);
  }

  Color textColor = Colors.white;

  if (isPlayerTile && score != null && par != null) {
    tileColor = getScoreColor(score, par);
    textColor = Colors.black;
  }

  return Padding(
    padding: const EdgeInsets.all(0.1),
    child: SizedBox(
      width: 70,
      height: isPlayerTile ? 50 : 25,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: theme.primaryColor.withOpacity(0.05),
              spreadRadius: 5,
              blurRadius: 15,
            ),
          ],
          color: tileColor,
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                //if hole has no score then display "-" else display score"
                score == 0 ? '-' : text,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            if (relativeScore != null)
              Positioned(
                right: 2,
                top: 1,
                child: Text(
                  relativeScore > 0 ? '+$relativeScore' : '$relativeScore',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
