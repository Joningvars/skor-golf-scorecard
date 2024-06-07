import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:score_card/theme/theme_helper.dart';

class IntroPage1 extends StatelessWidget {
  BoxDecoration background = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: [
        theme.colorScheme.secondary,
        theme.primaryColor,
        theme.primaryColor,
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/course.svg',
            height: 200,
          ),
          const SizedBox(height: 30),
          const Text(
            '1. Velur völl',
            style: TextStyle(
                color: Color.fromARGB(255, 57, 143, 209),
                fontSize: 30,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 50),
          const Text(
            'Einfaldlega velur einn af mörgum völlum sem skor hefur upp á að bjóða!',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
