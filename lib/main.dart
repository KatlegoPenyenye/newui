import 'package:flutter/material.dart';
import 'package:new_animateduis/animatesheet.dart';
// import 'package:animated_uis/home_page.dart';
// import 'package:animated_uis/compuis.dart';
// import 'package:animated_uis/bottom_sheet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AnimationSheet(),
    );
  }
}
