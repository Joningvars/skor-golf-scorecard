import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:score_card/routes/app_routes.dart';
import 'package:score_card/widgets/welcome_button.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final String imagePath = 'assets/images/';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _precacheImages();
  }

  void _precacheImages() {
    precacheImage(AssetImage('${imagePath}skor_logo.png'), context);
  }

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
                SizedBox(height: safeAreaPadding.top),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 300,
                        height: 250,
                        child: Image.asset(
                          'assets/images/logo_res.png',
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
                      WelcomeScreenButton(
                        text: 'Hefja Hring',
                        onPressed: () {
                          Navigator.pushNamed(
                              context, AppRoutes.courseSelectScreen);
                        },
                      ),
                      SizedBox(height: size.height * 0.03),
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
                SizedBox(height: safeAreaPadding.bottom),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
