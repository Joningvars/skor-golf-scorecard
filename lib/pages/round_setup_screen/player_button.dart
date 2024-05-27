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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          SizedBox(
            width: 65,
            height: 65,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shadowColor: Colors.black),
              onPressed: onEdit,
              child: Text(
                player.initials,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
