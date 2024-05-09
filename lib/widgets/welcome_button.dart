import 'package:flutter/material.dart';

class WelcomeScreenButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  WelcomeScreenButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        fixedSize: Size(250, 60),
      ),
    );
  }
}
