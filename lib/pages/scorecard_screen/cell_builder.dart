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
  Color calculateColor(int score, int par) {
    if (score == par - 2) {
      return Colors.green;
    } else if (score == par - 1) {
      return Colors.red;
    } else if (score == par) {
      return const Color.fromARGB(255, 33, 109, 168);
    } else if (score == par + 1) {
      return Colors.grey.shade300;
    } else {
      return Colors.grey;
    }
  }

  Color textColor = Colors.white;

  if (isPlayerTile && score != null && par != null) {
    tileColor = calculateColor(score, par);
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
