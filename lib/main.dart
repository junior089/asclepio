import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'screens/activity.dart';
import 'screens/goals.dart';
import 'screens/profile.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(HealthApp());
}

class HealthApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.light,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontSize: 18),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.teal,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            textStyle: TextStyle(fontSize: 18),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
      ),
      home: DashboardScreen(),
      routes: {
        '/dashboard': (context) => DashboardScreen(),
        '/activity': (context) => ActivityScreen(),
        '/goals': (context) => GoalsScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
