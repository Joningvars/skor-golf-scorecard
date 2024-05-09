import 'package:score_card/models/hole.dart';

class GolfCourse {
  final String clubName;
  final String name;
  final String location;
  final int par;
  final List<Hole> holes;

  GolfCourse({
    required this.clubName,
    required this.location,
    required this.name,
    required this.par,
    required this.holes,
  });
}
