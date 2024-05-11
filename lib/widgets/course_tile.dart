import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/pages/hole_screen.dart';
import 'package:score_card/pages/round_setup_screen.dart';
import 'package:score_card/theme/custom_button_style.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';

class CourseTile extends StatelessWidget {
  final GolfCourse course;

  const CourseTile({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        children: [
          // Background image
          CardBackgroundImage(imageUrl: course.imgUrl),
          const CardShader(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShadowText(text: course.clubName),
                ShadowText(text: '(${course.name})'),
                smallerShadowText(text: course.location),
              ],
            ),
          ),
          const Positioned(
            bottom: 0,
            top: 120,
            right: 0,
            left: 00,
            child: CardHighlight(),
          ),
          Positioned(
            top: 130,
            bottom: 10,
            right: 10,
            left: 250,
            child: CardButton(
              course: course,
            ),
          ),
          // Tee lengths
          Positioned(
            top: 130,
            bottom: 10,
            right: 10,
            left: 10,
            child: Row(
              children: [
                TeeLength(
                  tee: course.whiteTee.toString(),
                  color: Colors.white,
                ),
                TeeLength(
                  tee: course.yellowTee.toString(),
                  color: Colors.yellow,
                ),
                TeeLength(
                  tee: course.blueTee.toString(),
                  color: Colors.blue,
                ),
                TeeLength(
                  tee: course.redTee.toString(),
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
      // Apply button style
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        'Velja',
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
          size: 18,
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
      height: 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(13),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
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
      height: 170,
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
