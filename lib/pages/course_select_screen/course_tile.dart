// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/pages/round_setup_screen/round_setup_screen.dart';

class CourseTile extends StatefulWidget {
  final GolfCourse course;

  const CourseTile({
    super.key,
    required this.course,
  });

  @override
  State<CourseTile> createState() => _CourseTileState();
}

class _CourseTileState extends State<CourseTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Stack(
        children: [
          CardBackgroundImage(imageUrl: widget.course.imgUrl),
          const CardShader(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShadowText(text: widget.course.clubName),
                ShadowText(text: '(${widget.course.name})'),
                smallerShadowText(text: widget.course.location),
              ],
            ),
          ),
          const Positioned(
            bottom: 0,
            top: 140,
            right: 0,
            left: 0,
            child: CardHighlight(),
          ),
          Positioned(
            top: 150,
            bottom: 10,
            right: 10,
            left: 230,
            child: CardButton(
              course: widget.course,
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
                  tee: widget.course.whiteTee.toString(),
                  color: Colors.white,
                ),
                TeeLength(
                  tee: widget.course.yellowTee.toString(),
                  color: Colors.yellow,
                ),
                TeeLength(
                  tee: widget.course.blueTee.toString(),
                  color: Colors.blue,
                ),
                TeeLength(
                  tee: widget.course.redTee.toString(),
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
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        HapticFeedback.lightImpact();

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
          borderRadius: BorderRadius.circular(30),
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(
          Icons.sports_golf_rounded,
          color: color,
          size: 20,
        ),
        Text(
          '${tee[0]}.${tee[1]}km',
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
        child: Image.asset(
          imageUrl,
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
