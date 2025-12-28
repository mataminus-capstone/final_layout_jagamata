import 'dart:async';
import 'package:flutter/material.dart';

class EyeExerciseController {
  int currentIndex = 0;
  int currentLoop = 1;
  final int maxLoop = 3;

  Timer? timer;

  final List<Alignment> positions = [
    Alignment.topLeft,
    Alignment.topRight,
    Alignment.bottomRight,
    Alignment.bottomLeft,
    Alignment.center,
  ];

  final List<String> instructions = [
    "Arahkan pandangan ke kiri atas",
    "Arahkan pandangan ke kanan atas",
    "Arahkan pandangan ke kanan bawah",
    "Arahkan pandangan ke kiri bawah",
    "Fokuskan pandangan ke tengah",
  ];

  bool get isFinished => currentLoop > maxLoop;

  void start(VoidCallback onUpdate) {
    timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (isFinished) {
        stop();
        return;
      }

      currentIndex++;

      if (currentIndex >= positions.length) {
        currentIndex = 0;
        currentLoop++;
      }

      onUpdate();
    });
  }

  void stop() {
    timer?.cancel();
  }
}
