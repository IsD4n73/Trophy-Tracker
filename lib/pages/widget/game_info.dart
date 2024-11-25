import 'package:flutter/material.dart';

class GameInfo extends StatelessWidget {
  final String difficulty, playthroughs, hours;
  const GameInfo({
    super.key,
    required this.difficulty,
    required this.playthroughs,
    required this.hours,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Difficulty: \n$difficulty",
            textAlign: TextAlign.center,
          ),
          Text(
            "Playthroughs:\n$playthroughs",
            textAlign: TextAlign.center,
          ),
          Text(
            "Hours: \n$hours",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
