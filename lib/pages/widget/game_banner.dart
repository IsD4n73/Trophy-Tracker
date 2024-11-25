import 'package:flutter/material.dart';

class GameBanner extends StatelessWidget {
  final String title, background;
  const GameBanner({
    super.key,
    required this.title,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.network(
          background,
          fit: BoxFit.cover,
        ),
        Center(
          child: Text(
            title,
            softWrap: true,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              backgroundColor: Colors.black38,
            ),
          ),
        ),
      ],
    );
  }
}
