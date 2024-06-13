import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/scorecard_screen/back9_widget.dart';
import 'package:score_card/pages/scorecard_screen/bottom_nav.dart';
import 'package:score_card/pages/scorecard_screen/front9_widget.dart';
import 'package:score_card/pages/scorecard_screen/players_widget.dart';
import 'package:score_card/pages/scorecard_screen/scorecard_header.dart';
import 'package:score_card/pages/scorecard_screen/save_round.dart';
import 'package:score_card/pages/scorecard_screen/scorecard_widget.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:score_card/providers/round_provider.dart';

class ScorecardScreen extends ConsumerWidget {
  final List<Player> players;
  final List<Hole> holes;
  final GolfCourse course;
  final bool fromMyScores;

  const ScorecardScreen({
    super.key,
    required this.players,
    required this.holes,
    required this.course,
    this.fromMyScores = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        automaticallyImplyLeading: false,
        actions: _buildAppBarActions(
          context,
          ref,
          players,
          holes,
          course,
          screenshotController,
          hasBack9Score,
          formattedDate,
          pixelRatio,
          currentOrientation,
          fromMyScores,
        ),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CourseInfoHeader(
              currentOrientation: currentOrientation,
              formattedDate: formattedDate,
              course: course,
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
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                          course: course,
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar:
          !fromMyScores && currentOrientation == Orientation.portrait
              ? ScoreCardBottomNav(
                  players: players,
                  holes: holes,
                  course: course,
                  screenshotController: screenshotController,
                  hasBack9Score: hasBack9Score,
                  pixelRatio: pixelRatio,
                  formattedDate: formattedDate,
                )
              : null,
    );
  }

  List<Widget> _buildAppBarActions(
    BuildContext context,
    WidgetRef ref,
    List<Player> players,
    List<Hole> holes,
    GolfCourse course,
    ScreenshotController screenshotController,
    bool hasBack9Score,
    String formattedDate,
    double pixelRatio,
    Orientation currentOrientation,
    bool fromMyScores,
  ) {
    if (fromMyScores) {
      return [
        IconButton(
          onPressed: () async {
            try {
              // takes a screenshot of the scorecard widget

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
        ),
      ];
    } else if (currentOrientation == Orientation.landscape) {
      //displaying the action buttons in the appbar
      // instead of the navbar when in landscape

      return [
        IconButton(
          onPressed: () {
            saveRound(context, players, holes, course);
            ref.read(roundProvider.notifier).endRound();
            for (var player in players) {
              player.resetScores();
            }
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: const Icon(
            Icons.check,
            color: Colors.green,
          ),
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
        ),
        IconButton(
          onPressed: () {
            _showDeleteConfirmationDialog(context, ref, players);
          },
          icon: const Icon(
            Icons.delete_forever_rounded,
            color: Colors.red,
          ),
        ),
      ];
    } else {
      return [];
    }
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, WidgetRef ref, List<Player> players) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eyða hring?'),
          content: const Text('Ertu viss um að þú viljir eyða hringnum?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hætta við'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                ref.read(roundProvider.notifier).endRound();
                for (var player in players) {
                  player.resetScores();
                }
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Eyða'),
            ),
          ],
        );
      },
    );
  }
}
