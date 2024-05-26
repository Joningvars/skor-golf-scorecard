import 'package:flutter/material.dart';
import 'package:score_card/theme/theme_helper.dart';

class WelcomeScreenButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;

  const WelcomeScreenButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.textColor,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370,
      child: Material(
        elevation: 1,
        shadowColor: theme.primaryColor,
        borderRadius: BorderRadius.circular(8),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            fixedSize: const Size(230, 60),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
          ),
        ),
      ),
    );
  }
}
