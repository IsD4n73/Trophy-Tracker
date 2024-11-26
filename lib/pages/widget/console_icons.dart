import 'package:flutter/material.dart';

class ConsoleIcons extends StatelessWidget {
  final String console;
  const ConsoleIcons({super.key, required this.console});

  @override
  Widget build(BuildContext context) {
    switch (console.toLowerCase()) {
      case "ps3":
        return Image.asset(
          'assets/ps3.png',
          width: 35,
          height: 35,
        );
      case "ps4":
        return Image.asset(
          'assets/ps4.png',
          width: 35,
          height: 35,
        );
      case "ps5":
        return Image.asset(
          'assets/ps5.png',
          width: 35,
          height: 35,
        );
      case "vita":
        return Image.asset(
          'assets/psvita.png',
          width: 35,
          height: 35,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
