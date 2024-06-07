import 'package:flutter/material.dart';
import 'package:score_card/pages/onboarding_screen/onboarding_screen.dart';
import 'package:score_card/pages/welcome_screen/welcome_screen.dart';
import 'package:score_card/routes/app_routes.dart';
import 'package:score_card/theme/theme_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeHelper().changeTheme('primary');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }

  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('isFirstLaunch', false);
    }

    setState(() {
      _isFirstLaunch = isFirstLaunch;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      title: 'skor',
      debugShowCheckedModeBanner: false,
      home: OnBoardingScreen(),
      // initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
