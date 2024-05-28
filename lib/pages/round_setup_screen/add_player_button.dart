import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/pages/add_player_screen/add_player_screen.dart';
import 'package:score_card/theme/theme_helper.dart';

class AddPlayerButton extends StatelessWidget {
  final GolfCourse course;
  final Function(String, String, int) onAddPlayer;

  const AddPlayerButton({
    super.key,
    required this.course,
    required this.onAddPlayer,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: screenSize.width * 0.03,
          vertical: screenSize.height * 0.013),
      child: SizedBox(
        width: screenSize.width * 0.1,
        height: screenSize.width * 0.1,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: Colors.white,
            elevation: 2,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenSize.width * 0.02),
            ),
          ),
          onPressed: () {
            HapticFeedback.selectionClick();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddPlayerScreen(
                  course: course,
                  onAddPlayer: onAddPlayer,
                ),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
}
