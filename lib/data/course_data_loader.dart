import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:score_card/models/course.dart';
import 'package:score_card/models/hole.dart';

Future<List<GolfCourse>> getCourseData() async {
  try {
    // read file
    final jsonString = await rootBundle.loadString('lib/data/dummy.json');

    // parse JSON
    List<dynamic> courses = jsonDecode(jsonString);

    // create course list
    List<GolfCourse> golfCourses = [];

    // process courses
    for (var course in courses) {
      // create course object
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
                    handicap: holeJson['handicap'] ?? 0,
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

      // add course to list
      golfCourses.add(golfCourse);
    }

    // return course list
    return golfCourses;
  } catch (e) {
    // return empty list in case of error
    return [];
  }
}
