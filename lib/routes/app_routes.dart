import 'package:flutter/material.dart';
import 'package:score_card/pages/course_select_screen.dart';
import 'package:score_card/pages/my_scores_screen.dart';
import 'package:score_card/pages/welcome_screen.dart';

class AppRoutes {
  static const String myScoresScreen = '/my_scores_screen';
  static const String welcomeScreen = '/welcome_screen';
  static const String courseSelectScreen = '/hefja_hring_screen';
  static const String teeScreen = '/velja_teig_screen';
  static const String inputScoreScreen = '/skr_skor_screen';
  static const String appNavigationScreen = '/app_navigation_screen';
  static const String initialRoute = '/initialRoute';
  static const String exampleScreen = '/example_screen';
  static const String roundSetupScreen = '/example_screen';

  static Map<String, WidgetBuilder> routes = {
    myScoresScreen: (context) => MyScoresScreen(),
    welcomeScreen: (context) => WelcomeScreen(),
    courseSelectScreen: (context) => CourseSelectScreen(),
    initialRoute: (context) => WelcomeScreen(),
  };
}
