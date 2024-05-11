import 'dart:convert';
import 'dart:io';

import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';

List<GolfCourse> getCourseData() {
  try {
    // Read the JSON
    const fileName =
        '/Users/joningvarsson/StudioProjects/score_card/lib/data/dummy.json';
    final file = File(fileName);
    final jsonString = file.readAsStringSync();

    // Parse the JSON data
    List<dynamic> courses = jsonDecode(jsonString);

    // create a list to store the golf courses
    List<GolfCourse> golfCourses = [];

    // get club names
    for (var course in courses) {
      // Create a GolfCourse object from JSON
      final golfCourse = GolfCourse(
        clubName: course['club'] ?? '',
        name: course['course'] ?? '',
        location: course['location'] ?? '',
        imgUrl: course['imgUrl'] ?? '',
        par: course['par'] ?? 0,
        whiteTee: course['distance']['white'] ?? 0,
        yellowTee: course['distance']['yellow'] ?? 0,
        blueTee: course['distance']['blue'] ?? 0,
        redTee: course['distance']['red'] ?? 0,
        holes: (course['holes'] as List?)
                ?.map(
                  (holeJson) => Hole(
                    number: holeJson['number'] ?? 0,
                    par: holeJson['par'] ?? 0,
                    whiteTee: course['distance']['white'] ?? 0,
                    yellowTee: course['distance']['yellow'] ?? 0,
                    blueTee: course['distance']['blue'] ?? 0,
                    redTee: course['distance']['red'] ?? 0,
                  ),
                )
                .toList() ??
            [],
      );

      // Add the golf course to the list
      golfCourses.add(golfCourse);
    }

    // Return the list of golf courses
    return golfCourses;
  } catch (e) {
    print('Error: $e');

    // Return an empty list in case of error
    return [];
  }
}
