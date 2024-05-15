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

    // Parse json
    List<dynamic> courses = jsonDecode(jsonString);

    // Create a list for courses
    List<GolfCourse> golfCourses = [];

    // Get club names
    for (var course in courses) {
      // Create a course from json
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
                    whiteTee: holeJson['distance']['white'] ?? 0,
                    yellowTee: holeJson['distance']['yellow'] ?? 0,
                    blueTee: holeJson['distance']['blue'] ?? 0,
                    redTee: holeJson['distance']['red'] ?? 0,
                  ),
                )
                .toList() ??
            [],
      );

      // Add course
      golfCourses.add(golfCourse);
    }

    // Return list of courses
    return golfCourses;
  } catch (e) {
    print('Error: $e');

    // Return an empty list if error
    return [];
  }
}
