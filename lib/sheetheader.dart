import 'package:flutter/material.dart';

class SheetHeader extends StatelessWidget {
  final double fontSize;
  final double topMargin;

  const SheetHeader(
      {super.key, required this.fontSize, required this.topMargin});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 32,
      child: IgnorePointer(
        child: Container(
          padding: EdgeInsets.only(top: topMargin, bottom: 12),
          decoration: const BoxDecoration(
            color: Color(0xFF162A49),
          ),
          child: Text(
            'Booked Exhibition',
            style: TextStyle(
              color: Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
