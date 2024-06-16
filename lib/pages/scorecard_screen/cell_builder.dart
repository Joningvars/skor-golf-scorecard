import 'package:flutter/material.dart';

Widget buildCell(
  String text, {
  double width = 50,
  bool isPlayerTile = false,
  double fontSize = 14,
  int? score,
  int? par,
  Color tileColor = const Color(0XFF195482),
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

  return SizedBox(
    width: 70,
    height: isPlayerTile ? 50 : 25,
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.05),
        color: tileColor,
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
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
  );
}
