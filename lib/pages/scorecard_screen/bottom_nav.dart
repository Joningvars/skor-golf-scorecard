import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/scorecard_screen/save_round.dart';
import 'package:score_card/pages/scorecard_screen/scorecard_widget.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:score_card/providers/round_provider.dart';

class ScoreCardBottomNav extends ConsumerWidget {
  const ScoreCardBottomNav({
    super.key,
    required this.players,
    required this.holes,
    required this.course,
    required this.screenshotController,
    required this.hasBack9Score,
    required this.pixelRatio,
    required this.formattedDate,
  });

  final List<Player> players;
  final List<Hole> holes;
  final GolfCourse course;
  final ScreenshotController screenshotController;
  final bool hasBack9Score;
  final double pixelRatio;
  final String formattedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      backgroundColor: theme.colorScheme.secondary,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.check,
            color: Colors.green,
          ),
          label: 'Vista',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.ios_share,
          ),
          label: 'Deila',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.delete_forever_rounded,
            color: Colors.red,
          ),
          label: 'Eyða',
        ),
      ],
      onTap: (index) async {
        switch (index) {
          case 0:
            HapticFeedback.lightImpact();
            saveRound(context, players, holes, course);
            ref.read(roundProvider.notifier).endRound();
            for (var player in players) {
              player.resetScores();
            }
            break;
          case 1:
            HapticFeedback.lightImpact();
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
            break;
          case 2:
            HapticFeedback.lightImpact();
            _showDeleteConfirmationDialog(context, ref);
            break;
        }
      },
    );
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
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
              },
              child: const Text('Hætta við'),
            ),
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(context).pop();
                _deleteRound(context, ref);
              },
              child: const Text('Eyða'),
            ),
          ],
        );
      },
    );
  }

  void _deleteRound(BuildContext context, WidgetRef ref) {
    ref.read(roundProvider.notifier).endRound();
    Navigator.popUntil(context, (route) => route.isFirst);
    for (var player in players) {
      player.resetScores();
    }
  }
}
