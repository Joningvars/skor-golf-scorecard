import 'package:flutter/material.dart';
import 'package:score_card/models/course.dart';
import 'package:score_card/pages/course_select_screen/course_tile.dart';

class CustomSearchDelegate extends SearchDelegate<GolfCourse> {
  final List<GolfCourse> courses;

  CustomSearchDelegate({required this.courses});

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: theme.primaryColor,
      ),
      scaffoldBackgroundColor: theme.primaryColor,
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white24),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.white,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new,
        color: Colors.white,
      ),
      onPressed: () {
        close(
            context,
            GolfCourse(
                clubName: '',
                imgUrl: '',
                location: '',
                yellowTee: 0,
                blueTee: 0,
                redTee: 0,
                whiteTee: 0,
                name: '',
                par: 0,
                holes: []));
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final List<GolfCourse> resultList = courses
        .where((course) =>
            course.name.toLowerCase().contains(query.toLowerCase()) ||
            course.clubName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: resultList.length,
      itemBuilder: (context, index) {
        return CourseTile(course: resultList[index]);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<GolfCourse> courseNames = courses
        .where(
            (course) => course.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    final List<GolfCourse> clubNames = courses
        .where((course) =>
            course.clubName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    final List<GolfCourse> suggestionList = [...courseNames, ...clubNames];

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final course = suggestionList[index];
        final nameHighlight = _buildHighlightedText(course.name, query);
        final clubHighlight = _buildHighlightedText(course.clubName, query);

        return ListTile(
          title: nameHighlight,
          subtitle: clubHighlight,
          onTap: () {
            query = course.name;
            showResults(context);
          },
        );
      },
    );
  }

  RichText _buildHighlightedText(String text, String query) {
    final startIndex = text.toLowerCase().indexOf(query.toLowerCase());
    if (startIndex == -1) {
      return RichText(
        text: TextSpan(
          text: text,
          style: const TextStyle(color: Colors.grey),
        ),
      );
    }

    final endIndex = startIndex + query.length;

    return RichText(
      text: TextSpan(
        text: text.substring(0, startIndex),
        style: const TextStyle(color: Colors.grey),
        children: [
          TextSpan(
            text: text.substring(startIndex, endIndex),
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: text.substring(endIndex),
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
