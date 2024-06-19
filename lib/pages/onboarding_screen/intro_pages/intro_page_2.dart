import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:score_card/theme/theme_helper.dart';

class IntroPage2 extends StatelessWidget {
  final BoxDecoration background = BoxDecoration(
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

  IntroPage2({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      decoration: background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/golfer.svg',
            height: 200,
          ),
          const SizedBox(height: 30),
          const Text(
            '2. Skráir golfara',
            style: TextStyle(
                color: Color.fromARGB(255, 57, 143, 209),
                fontSize: 30,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 40),
          const Text(
            'Skráðu þig og eða allt hollið! Með Skor getur þú auðveldlega haldið utan um alla kylfinga í hópnum þínum.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w200,
            ),
          )
        ],
      ),
    );
  }
}
