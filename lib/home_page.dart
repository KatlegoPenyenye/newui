import 'package:flutter/material.dart';
import 'package:new_animateduis/bottom_sheet.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 8),
                SizedBox(height: 40),
                SizedBox(height: 8),
              ],
            ),
          ),
          HomePage(), //use ExhibitionBottomSheet or ScrollableExhibitionSheet
        ],
      ),
    );
  }
}
