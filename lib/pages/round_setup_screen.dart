import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/pages/hole_screen.dart';
import 'package:score_card/widgets/background_blob.dart';
import 'package:score_card/widgets/customAppBar.dart';

class RoundSetupScreen extends StatefulWidget {
  RoundSetupScreen({super.key, required this.course});
  GolfCourse course;

  @override
  State<RoundSetupScreen> createState() => _RoundSetupScreenState();
}

class _RoundSetupScreenState extends State<RoundSetupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Velja teig'),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                CustomTeeButton(
                  text: widget.course.whiteTee.toString(),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HoleDetailPage(
                          hole: widget.course.holes[0],
                          selectedTee: widget.course.whiteTee,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTeeButton(
                  text: widget.course.yellowTee.toString(),
                  color: Colors.yellow,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HoleDetailPage(
                          hole: widget.course.holes[0],
                          selectedTee: widget.course.yellowTee,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTeeButton(
                  text: widget.course.blueTee.toString(),
                  color: Colors.blue,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HoleDetailPage(
                          hole: widget.course.holes[0],
                          selectedTee: widget.course.blueTee,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTeeButton(
                  text: widget.course.redTee.toString(),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HoleDetailPage(
                          hole: widget.course.holes[0],
                          selectedTee: widget.course.redTee,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          //add players

          // Container(
          //   child: ,
          // ),
          const BackgroundBlob(),
        ],
      ),
    );
  }
}

class CustomTeeButton extends StatelessWidget {
  const CustomTeeButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.color,
  }) : super(key: key);

  final VoidCallback onPressed;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          width: 300,
          height: 80,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_golf_rounded,
                size: 60,
                color: color,
              ),
              const SizedBox(width: 20),
              Text(
                '$text m',
                style: TextStyle(
                  color: color,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
