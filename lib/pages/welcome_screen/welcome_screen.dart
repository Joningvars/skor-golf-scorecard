import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_card/models/round.dart';
import 'package:score_card/pages/hole_screen/hole_screen.dart';
import 'package:score_card/routes/app_routes.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:score_card/pages/welcome_screen/welcome_button.dart';
import 'package:score_card/providers/round_provider.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  final String imagePath = 'assets/images/';

  @override
  void initState() {
    super.initState();
    _setPortraitMode();
    _checkForUnfinishedRound();
  }

  void _setPortraitMode() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _checkForUnfinishedRound() async {
    await ref.read(roundProvider.notifier).loadSavedRound();
    final round = ref.read(roundProvider);
    if (round != null) {
      _showContinueRoundDialog(round);
    }
  }

  void _showContinueRoundDialog(Round round) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ókláraður hringur'),
          content: const Text('Þú átt ókláraðan hring, viltu halda áfram?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _continueRound(round);
              },
              child: const Text('Já'),
            ),
            TextButton(
              onPressed: () {
                ref.read(roundProvider.notifier).endRound();
                Navigator.of(context).pop();
              },
              child: const Text('Nei'),
            ),
          ],
        );
      },
    );
  }

  void _continueRound(Round round) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HoleDetailPage(
          holes: round.holes,
          course: round.golfcourse,
          selectedTee: round.players.first.selectedTee,
          players: round.players,
        ),
      ),
    ).then((_) {
      _setPortraitMode();
    });
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
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
                            'assets/images/logo-smaller.png',
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
                                  context, AppRoutes.courseSelectScreen)
                              .then((_) {
                            _setPortraitMode();
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      WelcomeScreenButton(
                        textColor: theme.primaryColor,
                        color: const Color.fromARGB(150, 233, 233, 233),
                        text: 'Mínir Hringir',
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.pushNamed(context, AppRoutes.myScoresScreen)
                              .then((_) {
                            _setPortraitMode();
                          });
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
