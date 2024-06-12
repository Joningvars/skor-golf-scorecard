// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:score_card/data/course_data_loader.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/pages/course_select_screen/custom_search.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:score_card/pages/course_select_screen/course_tile.dart';

class CourseSelectScreen extends StatefulWidget {
  const CourseSelectScreen({super.key});

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
        foregroundColor: Colors.white,
        title: SizedBox(
          height: 150,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.asset('assets/images/skor_logo.png'),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          FutureBuilder<List<GolfCourse>>(
            future: _coursesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(); // placeholder
              } else if (snapshot.hasError) {
                return IconButton(
                  icon: const Icon(Icons.error),
                  onPressed: () {},
                );
              } else if (snapshot.hasData) {
                return IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(courses: snapshot.data!),
                    );
                  },
                );
              }
              return Container(); //placeholder
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                theme.colorScheme.secondary,
                theme.colorScheme.secondary,
                theme.primaryColor,
              ]),
        ),
        child: SafeArea(
          child: FutureBuilder<List<GolfCourse>>(
            future: _coursesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
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
        ),
      ),
    );
  }
}

class CourseCardBuilder extends StatelessWidget {
  const CourseCardBuilder({
    super.key,
    required this.courses,
  });

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
