import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:score_card/routes/app_routes.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:score_card/widgets/welcome_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  final String imagePath = 'assets/images/';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final safeAreaPadding = MediaQuery.of(context).padding;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                '${imagePath}golf_background.jpeg',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                color: Colors.black12,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: safeAreaPadding.top * 5),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.2,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 10,
                                blurRadius: 100,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/images/logo-res.png',
                            fit: BoxFit.contain,
                            frameBuilder: (BuildContext context, Widget child,
                                int? frame, bool wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded) {
                                return child;
                              }
                              return AnimatedOpacity(
                                opacity: frame == null ? 0 : 1,
                                duration: const Duration(seconds: 1),
                                child: child,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: size.height * 0.2),
                      WelcomeScreenButton(
                        textColor: Colors.white,
                        color: theme.colorScheme.primary,
                        text: 'Hefja Hring',
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(
                              context, AppRoutes.courseSelectScreen);
                        },
                      ),
                      const SizedBox(height: 15),
                      WelcomeScreenButton(
                        textColor: Colors.black,
                        color: const Color.fromARGB(150, 233, 233, 233),
                        text: 'Mínir Hringir',
                        onPressed: () {
                          HapticFeedback.lightImpact();

                          Navigator.pushNamed(
                              context, AppRoutes.myScoresScreen);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: safeAreaPadding.bottom),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
