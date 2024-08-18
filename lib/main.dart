import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:score_card/pages/onboarding_screen/onboarding_screen.dart';
import 'package:score_card/pages/welcome_screen/welcome_screen.dart';
import 'package:score_card/routes/app_routes.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  ThemeHelper().changeTheme('primary');
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(ProviderScope(
      child: MyApp(
    isFirstLaunch: isFirstLaunch,
  )));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.isFirstLaunch});

  final bool isFirstLaunch;

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      title: 'skor',
      debugShowCheckedModeBanner: false,
      home: widget.isFirstLaunch
          ? const OnBoardingScreen()
          : const WelcomeScreen(),
      routes: AppRoutes.routes,
    );
  }
}
