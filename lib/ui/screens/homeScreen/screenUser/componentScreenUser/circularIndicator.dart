import 'package:flutter/material.dart';

class CircularIndecator extends StatelessWidget {
  const CircularIndecator({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 50,
      left: 0,
      right: 0,
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.blue.shade800,
        ),
      ),
    );
  }
}
