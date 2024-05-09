import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:score_card/data/course_data_loader.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/widgets/background_blob.dart';
import 'package:score_card/widgets/course_tile.dart';

class CourseSelectScreen extends StatelessWidget {
  const CourseSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var course = getCourseData();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo.png',
          width: 50,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(children: [
        const BackgroundBlob(),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: BuildTiles(course: course),
        ),
      ]),
    );
  }
}

class BuildTiles extends StatelessWidget {
  const BuildTiles({
    super.key,
    required this.course,
  });

  final GolfCourse course;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return CourseTile(
          course: course,
        );
      },
    );
  }
}
