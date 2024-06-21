// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/round.dart';
import 'package:score_card/pages/course_select_screen/course_tile.dart';
import 'package:score_card/pages/scorecard_screen/scorecard_screen.dart';

class SavedRoundTile extends StatelessWidget {
  final Round round;

  const SavedRoundTile({
    super.key,
    required this.round,
  });

  @override
  Widget build(BuildContext context) {
    int totalStrokes = round.players.isNotEmpty
        ? round.players[0].strokes.fold(0, (prev, score) => prev + score)
        : 0;

    int relativeScore =
        round.golfcourse.par == 0 ? 0 : round.players[0].relativeScore;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        children: [
          CardBackgroundImage(imageUrl: round.golfcourse.imgUrl),
          const CardShader(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        width: 210,
                        child: ShadowText(text: round.golfcourse.clubName)),
                    ShadowText(text: round.golfcourse.name),
                    smallerShadowText(text: round.golfcourse.location),
                  ],
                ),
                const SizedBox(width: 30),
                FittedBox(
                  child: Text(
                    totalStrokes.toString(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 5,
                          color: Colors.black45,
                        ),
                        Shadow(
                          blurRadius: 30,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
                if (round.golfcourse.par != 0)
                  Text(
                    relativeScore > 0
                        ? '+$relativeScore'
                        : (relativeScore == 0 ? 'E' : '$relativeScore'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1, 1),
                          blurRadius: 4,
                          color: Colors.black54,
                        ),
                        Shadow(
                          blurRadius: 30,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (round.golfcourse.par != 0)
            const Positioned(
              bottom: 0,
              top: 140,
              right: 0,
              left: 00,
              child: CardHighlight(),
            ),
          Positioned(
            top: 150,
            bottom: 10,
            right: 10,
            left: 230,
            child: SizedBox(
              child: CardButton(
                round: round,
                course: round.golfcourse,
              ),
            ),
          ),
          // Tee lengths
          if (round.golfcourse.par != 0)
            Positioned(
              top: 160,
              bottom: 10,
              right: 10,
              left: 10,
              child: Row(
                children: [
                  TeeLength(
                    tee: round.golfcourse.whiteTee.toString(),
                    color: Colors.white,
                  ),
                  TeeLength(
                    tee: round.golfcourse.yellowTee.toString(),
                    color: Colors.yellow,
                  ),
                  TeeLength(
                    tee: round.golfcourse.blueTee.toString(),
                    color: Colors.blue,
                  ),
                  TeeLength(
                    tee: round.golfcourse.redTee.toString(),
                    color: Colors.red,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final GolfCourse course;
  final Round round;

  const CardButton({super.key, required this.course, required this.round});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.selectionClick();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScorecardScreen(
              course: round.golfcourse,
              players: round.players,
              holes: round.holes,
              fromMyScores: true,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: const Text(
        'Skoða',
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }
}

class smallerShadowText extends StatelessWidget {
  const smallerShadowText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).primaryTextTheme.titleSmall!.copyWith(
        fontWeight: FontWeight.bold,
        shadows: <Shadow>[
          Shadow(
            offset: const Offset(1, 3),
            blurRadius: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
          Shadow(
            blurRadius: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class ShadowText extends StatelessWidget {
  const ShadowText({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).primaryTextTheme.titleLarge!.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        shadows: <Shadow>[
          Shadow(
            offset: const Offset(1, 3),
            blurRadius: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
          Shadow(
            blurRadius: 30,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class CardShader extends StatelessWidget {
  const CardShader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: const Color.fromARGB(26, 0, 0, 0)),
    );
  }
}

class CardHighlight extends StatelessWidget {
  const CardHighlight({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(13),
              bottomRight: Radius.circular(13)),
          color: Color.fromARGB(102, 19, 51, 76)),
    );
  }
}
