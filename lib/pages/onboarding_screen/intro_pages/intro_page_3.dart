import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:score_card/theme/theme_helper.dart';

class IntroPage3 extends StatelessWidget {
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
      decoration: background,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/score.svg',
            height: 200,
          ),
          const SizedBox(height: 30),
          const Text(
            '3. Skráir skor!',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromARGB(255, 57, 143, 209),
                fontSize: 30,
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 20),
          const Text(
            'Haltu utan um skorið! Með Skor getur þú auðveldlega skráð og fylgst með öllum þínum höggum á hverju holu. Vistaðu hringinn þinn í "Mínir hringir" og deildu honum með vinum!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w200,
            ),
          ),
        ],
      ),
    );
  }
}
