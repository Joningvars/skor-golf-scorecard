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

  Map<String, dynamic> toJson() {
    return {
      'clubName': clubName,
      'imgUrl': imgUrl,
      'location': location,
      'yellowTee': yellowTee,
      'blueTee': blueTee,
      'redTee': redTee,
      'whiteTee': whiteTee,
      'name': name,
      'par': par,
      'holes': holes.map((hole) => hole.toJson()).toList(),
    };
  }

  factory GolfCourse.fromJson(Map<String, dynamic> json) {
    List<dynamic> holesJson = json['holes'];
    List<Hole> parsedHoles =
        holesJson.map((holeJson) => Hole.fromJson(holeJson)).toList();

    return GolfCourse(
      clubName: json['clubName'],
      imgUrl: json['imgUrl'],
      location: json['location'],
      yellowTee: json['yellowTee'],
      blueTee: json['blueTee'],
      redTee: json['redTee'],
      whiteTee: json['whiteTee'],
      name: json['name'],
      par: json['par'],
      holes: parsedHoles,
    );
  }

  //create an empty GolfCourse
  static GolfCourse defaultCourse() {
    return GolfCourse(
      clubName: 'Hringur án vallar',
      imgUrl: 'assets/course_images/placeholder.webp',
      location: '',
      yellowTee: 0,
      blueTee: 0,
      redTee: 0,
      whiteTee: 0,
      name: 'enginn völlur valinn',
      par: 0,
      holes: List.generate(
          18,
          (index) => Hole(
                yellowTee: 0,
                handicap: 0,
                blueTee: 0,
                redTee: 0,
                whiteTee: 0,
                number: index + 1,
                par: 0,
              )),
    );
  }
}
