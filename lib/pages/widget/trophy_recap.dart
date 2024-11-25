import 'package:flutter/material.dart';

class TrophyRecap extends StatelessWidget {
  final String platinum, gold, silver, bronze;
  const TrophyRecap({
    super.key,
    required this.platinum,
    required this.gold,
    required this.silver,
    required this.bronze,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Text(platinum),
            Icon(
              Icons.emoji_events,
              color: Colors.blue,
            ),
          ],
        ),
        Row(
          children: [
            Text(gold),
            Icon(
              Icons.emoji_events,
              color: Colors.yellow,
            ),
          ],
        ),
        Row(
          children: [
            Text(silver),
            Icon(
              Icons.emoji_events,
              color: Colors.grey,
            ),
          ],
        ),
        Row(
          children: [
            Text(bronze),
            Icon(
              Icons.emoji_events,
              color: Colors.brown,
            ),
          ],
        ),
      ],
    );
  }
}
