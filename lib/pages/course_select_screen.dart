import 'package:flutter/material.dart';
import 'package:score_card/data/course_data_loader.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:score_card/widgets/course_tile.dart';

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
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
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

class CustomSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // final suggestionList = query.isEmpty
    //     ? []
    //     : courses.where((course) => course.name.toLowerCase().startsWith(query.toLowerCase())).toList();
    final suggestionList = [];

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: RichText(
            text: TextSpan(
              text: suggestionList[index].name.substring(0, query.length),
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: suggestionList[index].name.substring(query.length),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          onTap: () {
            query = suggestionList[index].name;
            showResults(context);
          },
        );
      },
    );
  }
}
