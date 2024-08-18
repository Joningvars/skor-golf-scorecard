import 'package:flutter/material.dart';
import 'package:score_card/pages/onboarding_screen/intro_pages/intro_page.dart';
import 'package:score_card/pages/onboarding_screen/intro_pages/intro_page_1.dart';
import 'package:score_card/pages/onboarding_screen/intro_pages/intro_page_2.dart';
import 'package:score_card/pages/onboarding_screen/intro_pages/intro_page_3.dart';
import 'package:score_card/pages/welcome_screen/welcome_screen.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  bool lastPage = false;

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
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: background,
        child: Stack(children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                lastPage = (index == 3);
              });
            },
            controller: _controller,
            children: [
              const IntroPage(),
              IntroPage1(),
              IntroPage2(),
              IntroPage3(),
            ],
          ),
          Container(
              alignment: const Alignment(0, 0.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(3);
                    },
                    child: const Text(
                      'sleppa',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: _controller,
                    count: 4,
                    effect: const ColorTransitionEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Color.fromARGB(255, 5, 121, 216),
                    ),
                  ),
                  lastPage
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WelcomeScreen()));
                          },
                          child: const Icon(
                            Icons.check,
                            color: Colors.white70,
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            _controller.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white70,
                          ),
                        )
                ],
              ))
        ]),
      ),
    );
  }
}
