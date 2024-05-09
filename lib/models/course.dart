import 'package:score_card/models/hole.dart';

class GolfCourse {
  final String clubName;
  final String name;
  final String location;
  final int whiteTee;
  final int yellowTee;
  final int blueTee;
  final int redTee;
  final int par;
  final List<Hole> holes;
  final String imgUrl;

  GolfCourse({
    required this.clubName,
    required this.imgUrl,
    required this.location,
    required this.yellowTee,
    required this.blueTee,
    required this.redTee,
    required this.whiteTee,
    required this.name,
    required this.par,
    required this.holes,
  });
}
