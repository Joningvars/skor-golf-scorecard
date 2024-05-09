import 'dart:convert';
import 'dart:io';

import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';

GolfCourse getCourseData() {
  try {
    // Read the JSON
    const fileName =
        '/Users/joningvarsson/StudioProjects/score_card/lib/data/dummy.json';
    final file = File(fileName);
    final jsonString = file.readAsStringSync();

    // parse the json
    final jsonData = jsonDecode(jsonString);

    // Create a GolfCourse object from JSON
    final golfCourse = GolfCourse(
      clubName: jsonData['club'] ?? '',
      name: jsonData['course'] ?? '',
      location: jsonData['location'] ?? '',
      imgUrl: jsonData['imgUrl'] ?? '',
      par: jsonData['par'] ?? 0,
      whiteTee: jsonData['distance']['white'] ?? 0,
      yellowTee: jsonData['distance']['yellow'] ?? 0,
      blueTee: jsonData['distance']['blue'] ?? 0,
      redTee: jsonData['distance']['red'] ?? 0,
      holes: (jsonData['holes'] as List?)
              ?.map(
                (holeJson) => Hole(
                  number: holeJson['number'] ?? 0,
                  par: holeJson['par'] ?? 0,
                  distance: holeJson['distance'] ?? 0,
                  description: holeJson['description'] ?? '',
                ),
              )
              .toList() ??
          [],
    );

    // print(golfCourse.name);
    // print(golfCourse.clubName);
    // print(golfCourse.location);
    // print(golfCourse.par);
    // print(golfCourse.holes);

    return golfCourse;

    //handle error
  } catch (e) {
    print('Error: $e');

    return GolfCourse(
      clubName: 'could not find',
      name: 'error loading course',
      location: '',
      par: 0,
      holes: [],
      redTee: 0,
      yellowTee: 0,
      blueTee: 0,
      whiteTee: 0,
      imgUrl: '',
    );
  }
}
