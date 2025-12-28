import 'package:flutter/material.dart';
import 'package:jagamata/controllers/eye_exercise_controller.dart';
import 'package:jagamata/widgets/exercise_circle.dart';

class EyeExercisePage extends StatefulWidget {
  const EyeExercisePage({super.key});

  @override
  State<EyeExercisePage> createState() => _EyeExercisePageState();
}

class _EyeExercisePageState extends State<EyeExercisePage> {
  final EyeExerciseController controller = EyeExerciseController();

  @override
  void initState() {
    super.initState();
    controller.start(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller.isFinished) {
      return Scaffold(
        appBar: AppBar(title: const Text("Senam Mata")),
        body: const Center(
          child: Text(
            "Senam mata selesai 🎉\nSilakan istirahatkan mata Anda",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Senam Mata")),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                children: [
                  Text(
                    controller.instructions[controller.currentIndex],
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    "Putaran ${controller.currentLoop} dari ${controller.maxLoop}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: controller.positions[controller.currentIndex],
            child: const Padding(
              padding: EdgeInsets.all(40),
              child: ExerciseCircle(),
            ),
          ),
        ],
      ),
    );
  }
}
