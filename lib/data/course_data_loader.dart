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
      clubName: jsonData['clubName'] ?? '',
      name: jsonData['name'] ?? '',
      location: jsonData['location'] ?? '',
      par: jsonData['par'] ?? 0,
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

    print(golfCourse.name);
    print(golfCourse.clubName);
    print(golfCourse.location);
    print(golfCourse.par);
    print(golfCourse.holes);

    return golfCourse;

    //handle error
  } catch (e) {
    print('Error: $e');

    return GolfCourse(
      clubName: '',
      name: '',
      location: '',
      par: 0,
      holes: [],
    );
  }
}
