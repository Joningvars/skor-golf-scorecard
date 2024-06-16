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
    return ElevatedButton(
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
              size: 60,
              color: color,
            ),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
