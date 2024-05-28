import 'package:flutter/material.dart';
import 'package:score_card/models/player.dart';

class PlayerButton extends StatelessWidget {
  final Player player;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const PlayerButton({
    super.key,
    required this.player,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.03,
      ),
      child: Column(
        children: [
          SizedBox(
            width: screenSize.width * 0.15,
            height: screenSize.width * 0.15,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                elevation: 3,
                shadowColor: Colors.black,
              ),
              onPressed: onEdit,
              child: Text(
                player.initials,
                style: TextStyle(
                  fontSize: screenSize.width * 0.05,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
