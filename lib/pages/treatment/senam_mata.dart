import 'package:flutter/material.dart';
import 'package:jagamata/controllers/senam_mata_logic.dart';
import 'package:jagamata/widgets/moving_dot.dart';

class SenamMata extends StatefulWidget {
  const SenamMata({super.key});

  @override
  State<SenamMata> createState() => _SenamMataState();
}

class _SenamMataState extends State<SenamMata>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late EyeExerciseController1 _exerciseController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _exerciseController = EyeExerciseController1(
      controller: _animationController,
    );

    _exerciseController.setExercise(ExerciseType.horizontal);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void changeExercise(ExerciseType type) {
    setState(() {
      _animationController.reset();
      _exerciseController.setExercise(type);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Senam Mata")),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Text(
            _exerciseController.instruction,
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 30),

          Expanded(child: MovingDot(animation: _exerciseController.animation)),

          Wrap(
            spacing: 10,
            children: [
              ElevatedButton(
                onPressed: () => changeExercise(ExerciseType.horizontal),
                child: const Text("Kiri-Kanan"),
              ),
              ElevatedButton(
                onPressed: () => changeExercise(ExerciseType.vertical),
                child: const Text("Atas-Bawah"),
              ),
              ElevatedButton(
                onPressed: () => changeExercise(ExerciseType.diagonal),
                child: const Text("Diagonal"),
              ),
              ElevatedButton(
                onPressed: () => changeExercise(ExerciseType.circular),
                child: const Text("Lingkaran"),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
