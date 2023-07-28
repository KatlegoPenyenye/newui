import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  final int index;
  final String assetName;
  final String assetTitle;
  final String assetDate;

  const DetailPage(
      {super.key,
      required this.index,
      required this.assetName,
      required this.assetTitle,
      required this.assetDate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Page'),
      ),
      body: Center(
        child: Column(
          children: [
            Center(
              child: Text(assetName),
            ),
            Image.asset(
              'assets/$assetName',
              width: 120.0,
              height: 120.0,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
