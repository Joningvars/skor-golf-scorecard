import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/round.dart';
import 'package:score_card/pages/round_setup_screen.dart';

import 'package:transparent_image/transparent_image.dart';

class SavedRoundTile extends StatelessWidget {
  final Round round;

  const SavedRoundTile({
    Key? key,
    required this.round,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int totalStrokes =
        round.players.isNotEmpty && round.players[0].strokes != null
            ? round.players[0].strokes.fold(0, (prev, score) => prev + score)
            : 0;

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
                    ShadowText(text: round.golfcourse.clubName),
                    ShadowText(text: '(${round.golfcourse.name})'),
                    smallerShadowText(text: round.golfcourse.location),
                  ],
                ),
                SizedBox(width: 30),
                Text(
                  totalStrokes.toString(),
                  style: TextStyle(
                    fontSize: 60,
                    color: Colors.white,
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
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 0,
            top: 150,
            right: 0,
            left: 00,
            child: CardHighlight(),
          ),
          Positioned(
            top: 160,
            bottom: 10,
            right: 10,
            left: 250,
            child: SizedBox(
              child: CardButton(
                course: round.golfcourse,
              ),
            ),
          ),
          // Tee lengths
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

  const CardButton({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RoundSetupScreen(
              course: course,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Skoða',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class TeeLength extends StatelessWidget {
  const TeeLength({super.key, required this.tee, required this.color});

  final String tee;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.sports_golf_rounded,
          color: color,
          size: 20,
        ),
        Text(
          '${tee}m',
          style: const TextStyle(
              color: Color.fromARGB(255, 226, 226, 226),
              fontSize: 10,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class CardBackgroundImage extends StatelessWidget {
  const CardBackgroundImage({
    super.key,
    required this.imageUrl,
  });

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
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