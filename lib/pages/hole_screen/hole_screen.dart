// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';
import 'package:score_card/models/player.dart';
import 'package:score_card/pages/hole_screen/hole_detail.dart';
import 'package:score_card/pages/scorecard_screen/scorecard_screen.dart';

class HoleDetailPage extends StatefulWidget {
  final List<Hole> holes;
  final int selectedTee;
  final List<Player> players;
  final GolfCourse course;

  const HoleDetailPage({
    super.key,
    required this.holes,
    required this.course,
    required this.selectedTee,
    required this.players,
  });

  @override
  _HoleDetailPageState createState() => _HoleDetailPageState();
}

class _HoleDetailPageState extends State<HoleDetailPage> {
  late PageController _pageController;

  @override
  void initState() {
    for (Player player in widget.players) {
      player.resetScores();
    }
    super.initState();
    _pageController = PageController(initialPage: 0);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void _setOrientationForScorecard(bool isScorecard) {
    if (isScorecard) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.holes.length + 1,
        onPageChanged: (index) {
          _setOrientationForScorecard(index == widget.holes.length);
        },
        itemBuilder: (context, index) {
          if (index < widget.holes.length) {
            return HoleDetail(
              currentHole: widget.holes[index],
              currentHoleIndex: index,
              totalHoles: widget.holes.length,
              course: widget.course,
              players: widget.players,
              selectedTee: widget.selectedTee,
            );
          } else {
            return ScorecardScreen(
              players: widget.players,
              holes: widget.holes,
              course: widget.course,
            );
          }
        },
      ),
    );
  }
}
