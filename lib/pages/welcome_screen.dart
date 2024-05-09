import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:score_card/routes/app_routes.dart';
import 'package:score_card/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final String imagePath = 'assets/images/';

  void _courseSelectNav(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.courseSelectScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('${imagePath}welcome_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              children: [
                SizedBox(),
              ],
            ),
            Stack(children: [
              Image.asset(
                '${imagePath}vecctor.png',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              Positioned(
                child: Center(
                  child: Column(
                    children: [
                      Image.asset('assets/images/logo.png'),
                      const SizedBox(
                        height: 175,
                      ),
                      WelcomeScreenButton(
                        text: 'Hefja Hring',
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoutes.courseSelectScreen);
                        },
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      WelcomeScreenButton(
                        text: 'Mínir Hringir',
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoutes.myScoresScreen);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
