import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/scorecard_screen/back9_widget.dart';
import 'package:score_card/pages/scorecard_screen/bottom_nav.dart';
import 'package:score_card/pages/scorecard_screen/cell_builder.dart';
import 'package:score_card/pages/scorecard_screen/front9_widget.dart';
import 'package:score_card/pages/scorecard_screen/players_widget.dart';
import 'package:score_card/pages/scorecard_screen/scorecard_header.dart';
import 'package:score_card/pages/scorecard_screen/save_round.dart';
import 'package:score_card/pages/scorecard_screen/scorecard_widget.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:score_card/providers/round_provider.dart';

class ScorecardScreen extends ConsumerStatefulWidget {
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
  ScorecardScreenState createState() => ScorecardScreenState();
}

class ScorecardScreenState extends ConsumerState<ScorecardScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    // Allowing both portrait and landscape modes for ScorecardScreen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Resetting to portrait mode only when leaving ScorecardScreen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hasBack9Score = widget.players[0].strokes.length > 9 &&
        widget.players[0].strokes.sublist(9, 18).any((stroke) => stroke != 0);
    Orientation currentOrientation = MediaQuery.of(context).orientation;

    var now = DateTime.now();
    var formatter = DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    double pixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: _buildAppBarActions(
          context,
          ref,
          widget.players,
          widget.holes,
          widget.course,
          screenshotController,
          hasBack9Score,
          formattedDate,
          pixelRatio,
          currentOrientation,
          widget.fromMyScores,
        ),
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            CourseInfoHeader(
              currentOrientation: currentOrientation,
              formattedDate: formattedDate,
              course: widget.course,
            ),
          ],
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
          left: false,
          child: Screenshot(
            controller: screenshotController,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (currentOrientation == Orientation.landscape) {
                  // Landscape layout
                  return Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildCell('Par', width: 100),
                          buildCell('Gulur(M)', width: 100),
                          buildCell('Forgjöf', width: 100),
                          buildCell('Hola', width: 100),
                          for (Player player in widget.players)
                            buildCell(
                              player.initials,
                              width: 100,
                              isPlayerTile: true,
                            ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Front9Widget(
                                  players: widget.players, holes: widget.holes),
                              if (hasBack9Score && widget.holes.length > 9)
                                Back9Widget(
                                  players: widget.players,
                                  holes: widget.holes,
                                  course: widget.course,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  // Portrait layout
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nafn:',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                'Högg:',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        for (var player in widget.players)
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  '${player.firstName} ${player.lastName}'
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const Spacer(),
                                buildPlayerTotalStrokes(player, widget.course),
                              ],
                            ),
                          ),
                        const SizedBox(height: 30),
                        _buildScoreCard(
                          players: widget.players,
                          holes: widget.holes,
                          hasBack9Score: hasBack9Score,
                          course: widget.course,
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          // Checks if the scorecard screen is being accessed from my scores or not
          !widget.fromMyScores && currentOrientation == Orientation.portrait
              ? ScoreCardBottomNav(
                  players: widget.players,
                  holes: widget.holes,
                  course: widget.course,
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
            // Takes a screenshot of the scorecard widget and shares it
            try {
              final image = await screenshotController.captureFromWidget(
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
            // Takes a screenshot of the scorecard widget and shares it
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
            _showDeleteConfirmationDialog(context, ref);
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

  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref) {
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
                for (var player in widget.players) {
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

class _buildScoreCard extends StatelessWidget {
  const _buildScoreCard({
    super.key,
    required this.players,
    required this.holes,
    required this.hasBack9Score,
    required this.course,
  });

  final List<Player> players;
  final List<Hole> holes;
  final bool hasBack9Score;
  final GolfCourse course;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            buildCell('Par', width: 100),
            buildCell('Gulur(M)', width: 100),
            buildCell('Forgjöf', width: 100),
            buildCell('Hola', width: 100),
            for (Player player in players)
              buildCell(
                player.initials,
                width: 100,
                isPlayerTile: true,
              ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
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
          ),
        ),
      ],
    );
  }
}
