import 'package:flutter/material.dart';

enum ExerciseType { center, horizontal, vertical, diagonal, circular }

class EyeExerciseController1 {
  final AnimationController controller;
  late Animation<Offset> animation;
  String instruction = '';

  EyeExerciseController1({required this.controller});

  void setExercise(ExerciseType type) {
    switch (type) {
      case ExerciseType.center:
        instruction = "Fokuskan pandangan ke titik tengah";
        animation = Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
        ).animate(controller);
        break;

      case ExerciseType.horizontal:
        instruction = "Ikuti titik dari kiri ke kanan";
        animation = Tween<Offset>(
          begin: const Offset(-1, 0),
          end: const Offset(1, 0),
        ).animate(controller);
        break;

      case ExerciseType.vertical:
        instruction = "Ikuti titik dari atas ke bawah";
        animation = Tween<Offset>(
          begin: const Offset(0, -1),
          end: const Offset(0, 1),
        ).animate(controller);
        break;

      case ExerciseType.diagonal:
        instruction = "Ikuti titik secara diagonal";
        animation = Tween<Offset>(
          begin: const Offset(-1, -1),
          end: const Offset(1, 1),
        ).animate(controller);
        break;

      case ExerciseType.circular:
        instruction = "Putar pandangan mengikuti lingkaran";
        animation = Tween<Offset>(
          begin: const Offset(1, 0),
          end: const Offset(-1, 0),
        ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
        break;
    }
    controller.repeat(reverse: true);
  }
}
