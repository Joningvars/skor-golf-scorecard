import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:score_card/data/course_data_loader.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/pages/course_select_screen/custom_search.dart';
import 'package:score_card/pages/round_setup_screen/round_setup_screen.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:score_card/pages/course_select_screen/course_tile.dart';

class CourseSelectScreen extends StatefulWidget {
  const CourseSelectScreen({super.key});

  @override
  CourseSelectScreenState createState() => CourseSelectScreenState();
}

class CourseSelectScreenState extends State<CourseSelectScreen> {
  late Future<List<GolfCourse>> _coursesFuture;

  @override
  void initState() {
    super.initState();
    _coursesFuture = getCourseData();
  }

  void navigateWithoutCourse() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            RoundSetupScreen(course: GolfCourse.defaultCourse()),
      ),
    );
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
                return Column(
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    backgroundColor:
                                        theme.colorScheme.secondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    navigateWithoutCourse();
                                  },
                                  child: Text(
                                    'Tómt skorkort',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade200),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SizedBox(
                                height: 40,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    backgroundColor:
                                        theme.colorScheme.secondary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    showSearch(
                                      context: context,
                                      delegate: CustomSearchDelegate(
                                          courses: courses),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: Colors.grey.shade200,
                                      ),
                                      Text(
                                        'Leita',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey.shade200),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: CourseCardBuilder(
                        courses: courses,
                      ),
                    ),
                  ],
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
