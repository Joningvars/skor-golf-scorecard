import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:score_card/data/course_data_loader.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/widgets/course_tile.dart';

class CourseSelectScreen extends StatefulWidget {
  const CourseSelectScreen({Key? key}) : super(key: key);

  @override
  _CourseSelectScreenState createState() => _CourseSelectScreenState();
}

class _CourseSelectScreenState extends State<CourseSelectScreen> {
  late Future<List<GolfCourse>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = getCourseData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Color(0XFF3270A2),
        title: SizedBox(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.asset('assets/images/skor_logo.png'),
            )),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FutureBuilder<List<GolfCourse>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final courses = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: CourseCardBuilder(courses: courses),
            );
          }
        },
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
