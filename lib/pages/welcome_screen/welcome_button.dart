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
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = MediaQuery.of(context).size;
        final isLandscape = screenSize.width > screenSize.height;
        final buttonWidth =
            isLandscape ? screenSize.width * 0.4 : screenSize.width * 0.85;
        final buttonHeight =
            isLandscape ? screenSize.height * 0.15 : screenSize.height * 0.075;
        final textSize =
            isLandscape ? screenSize.height * 0.05 : screenSize.width * 0.05;

        return SizedBox(
          width: buttonWidth,
          height: buttonHeight,
          child: Material(
            elevation: 1,
            shadowColor: theme.primaryColor,
            borderRadius: BorderRadius.circular(8),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                fixedSize: Size(buttonWidth, buttonHeight),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: textSize,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
