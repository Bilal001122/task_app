import 'package:flutter/material.dart';

import 'layouts/home_layout_with_nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        textTheme: Typography(platform: TargetPlatform.android).black,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.deepPurple,
          background: Colors.deepPurple,
          onSecondary: Colors.white,
          tertiary: Colors.white,
        ),
      ),
      home: HomeLayout(),
    );
  }
}
