import 'package:flutter/material.dart';

class BackgroundBlob extends StatelessWidget {
  const BackgroundBlob({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 400,
        bottom: 0,
        left: 0,
        right: 0,
        child: Image.asset(
          'assets/images/vector.png',
          fit: BoxFit.fill,
          width: double.infinity,
        ));
  }
}
