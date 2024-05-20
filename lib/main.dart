import 'package:flutter/material.dart';
import 'package:score_card/pages/welcome_screen.dart';
import 'package:score_card/routes/app_routes.dart';
import 'package:score_card/theme/theme_helper.dart';

var globalMessengerKey = GlobalKey<ScaffoldMessengerState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ThemeHelper().changeTheme('primary');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      title: 'skor',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
      initialRoute: AppRoutes.initialRoute,
      routes: AppRoutes.routes,
    );
  }
}
