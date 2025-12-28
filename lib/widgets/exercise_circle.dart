import 'package:flutter/material.dart';

class ExerciseCircle extends StatelessWidget {
  const ExerciseCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40, // ±2cm tergantung dpi
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.blue, width: 3),
      ),
    );
  }
}
