import 'package:flutter/material.dart';

class MovingDot extends StatelessWidget {
  final Animation<Offset> animation;

  const MovingDot({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: animation,
      child: Center(
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
