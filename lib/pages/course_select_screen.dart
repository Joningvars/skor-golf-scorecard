import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:score_card/data/course_data_loader.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/widgets/course_tile.dart';

class CourseSelectScreen extends StatelessWidget {
  const CourseSelectScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    var courses = getCourseData();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Color(0XFF3270A2),
        title: const Text(
          'Select a Course',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Stack(
        children: [
          // const BackgroundBlob(),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: CourseCardBuilder(courses: courses),
          ),
        ],
      ),
    );
  }
}

class CourseCardBuilder extends StatelessWidget {
  const CourseCardBuilder({
    Key? key,
    required this.courses,
  }) : super(key: key);

  final List<GolfCourse> courses;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return CourseTile(
          course: course,
        );
      },
    );
  }
}
