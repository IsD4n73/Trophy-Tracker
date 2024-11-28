import 'package:flutter/material.dart';

class ActivableScrollView extends StatelessWidget {
  final bool active;
  final Widget child;
  const ActivableScrollView({
    super.key,
    required this.active,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!active) {
      return child;
    }

    return SingleChildScrollView(
      child: child,
    );
  }
}
