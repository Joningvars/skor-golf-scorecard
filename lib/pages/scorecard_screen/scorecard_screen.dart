import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/scorecard_screen/back9_widget.dart';
import 'package:score_card/pages/scorecard_screen/front9_widget.dart';
import 'package:score_card/pages/scorecard_screen/helpers.dart';
import 'package:score_card/pages/scorecard_screen/players_widget.dart';
import 'package:score_card/pages/scorecard_screen/save_round.dart';
import 'package:score_card/routes/app_routes.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ScorecardScreen extends StatelessWidget {
  final List<Player> players;
  final List<Hole> holes;
  final GolfCourse course;

  const ScorecardScreen({
    super.key,
    required this.players,
    required this.holes,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    bool hasBack9Score = players[0].strokes.length > 9 &&
        players[0].strokes.sublist(9, 18).any((stroke) => stroke != 0);
    Orientation currentOrientation = MediaQuery.of(context).orientation;

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    final screenshotController = ScreenshotController();
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              for (var player in players) {
                player.resetScores();
              }
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.initialRoute,
                (route) => false,
              );
            },
            icon: const Icon(Icons.home),
          ),
          IconButton(
            onPressed: () {
              saveRound(context, players, holes, course);
              for (var player in players) {
                player.resetScores();
              }
            },
            icon: const Icon(Icons.save_alt_rounded),
          ),
          IconButton(
            onPressed: () async {
              try {
                final image = await screenshotController.captureFromLongWidget(
                  ScoreCard(
                    holes: holes,
                    players: players,
                    hasBack9Score: hasBack9Score,
                    course: course,
                  ),
                  pixelRatio: pixelRatio,
                  delay: const Duration(milliseconds: 10),
                );

                Share.shareXFiles(
                  [XFile.fromData(image, mimeType: "image/jpeg")],
                  text: formattedDate,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Úps.. eitthvað fór úrskeiðis!: $e')),
                );
              }
            },
            icon: const Icon(Icons.ios_share),
          )
        ],
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (currentOrientation == Orientation.landscape)
                    Text(
                      formattedDate,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  Text(
                    '${course.clubName} (${course.name})',
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Text(
                          'ÖRN',
                          style: TextStyle(color: Colors.green, fontSize: 10),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'FUGL',
                          style: TextStyle(color: Colors.red, fontSize: 10),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'PAR',
                          style: TextStyle(
                            color: Color.fromARGB(255, 33, 109, 168),
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'SKOLLI',
                          style:
                              TextStyle(color: Colors.grey[300], fontSize: 10),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          '2x SKOLLI',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: Image.asset(
                'assets/images/skor_logo.png',
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              theme.colorScheme.secondary,
              theme.primaryColor,
              theme.primaryColor,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (currentOrientation == Orientation.landscape) {
                // Landscape layout
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Front9Widget(players: players, holes: holes),
                      if (hasBack9Score && holes.length > 9)
                        Back9Widget(
                          players: players,
                          holes: holes,
                          course: course,
                        ),
                    ],
                  ),
                );
              } else {
                // Portrait layout
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nafn:',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            'Högg:',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      for (var player in players)
                        Row(
                          children: [
                            Text(
                              '${player.firstName} ${player.lastName}'
                                  .toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const Spacer(),
                            buildPlayerTotalStrokes(player, course),
                          ],
                        ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ScoreCard(
                            holes: holes,
                            players: players,
                            hasBack9Score: hasBack9Score,
                            course: course),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    super.key,
    required this.holes,
    required this.players,
    required this.hasBack9Score,
    required this.course,
  });

  final List<Hole> holes;
  final List<Player> players;
  final bool hasBack9Score;
  final GolfCourse course;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildFront9holes(holes),
            buildFront9Par(holes),
            buildFront9Length(holes),
            buildFront9Handicap(holes),
            for (var player in players) buildPlayerFront9(player, holes),
          ],
        ),
        if (hasBack9Score && holes.length > 9)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildBack9Holes(holes),
              buildBack9Par(holes),
              buildBack9Length(holes),
              buildBack9Handicap(holes),
              for (var player in players)
                buildPlayerBack9(player, holes, course),
            ],
          ),
      ],
    );
  }
}
