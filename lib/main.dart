import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(CampusApp());
}

class CampusApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Campus Events",
      theme: ThemeData(
        primaryColor: Color(0xFF1E3A8A),
        scaffoldBackgroundColor: Color(0xFFF3F4F6),
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: LoginScreen(),
    );
  }
}