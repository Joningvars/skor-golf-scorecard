import 'package:flutter/material.dart';
import 'package:score_card/theme/theme_helper.dart';

class WelcomeScreenButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;

  const WelcomeScreenButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.textColor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return SizedBox(
      width: screenSize.width * 0.85,
      height: screenSize.height * 0.075,
      child: Material(
        elevation: 1,
        shadowColor: theme.primaryColor,
        borderRadius: BorderRadius.circular(8),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            fixedSize: Size(screenSize.width * 0.6, screenSize.height * 0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: screenSize.width * 0.05,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
