import 'package:flutter/material.dart';
import 'package:score_card/theme/theme_helper.dart';

class CustomTeeButton extends StatelessWidget {
  const CustomTeeButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.color,
  });

  final VoidCallback onPressed;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isLandscape = screenSize.width > screenSize.height;
    final buttonWidth =
        isLandscape ? screenSize.width * 0.4 : screenSize.width * 0.85;
    final buttonHeight =
        isLandscape ? screenSize.height * 0.15 : screenSize.height * 0.075;
    final textSize =
        isLandscape ? screenSize.height * 0.1 : screenSize.width * 0.1;

    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 5,
            backgroundColor: theme.colorScheme.secondary,
            shadowColor: Colors.black),
        onPressed: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          height: 65,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_golf_rounded,
                size: textSize,
                color: color,
              ),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
