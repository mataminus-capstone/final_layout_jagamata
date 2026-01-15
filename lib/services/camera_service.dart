import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class CameraService {
  CameraController? controller;
  List<CameraDescription>? cameras;
  CameraLensDirection currentDirection = CameraLensDirection.front;

  Future<void> init() async {
    try {
      cameras = await availableCameras();
      if (cameras == null || cameras!.isEmpty) {
        throw Exception('Tidak ada kamera yang ditemukan');
      }
      
      // Try to find the preferred camera, otherwise use the first available
      try {
         await _startCamera(currentDirection);
      } catch (e) {
         // Fallback to first available if preferred not found
         if (cameras!.isNotEmpty) {
           currentDirection = cameras!.first.lensDirection;
           await _startCamera(currentDirection);
         }
      }
    } catch (e) {
      debugPrint("CameraService init error: $e");
      rethrow;
    }
  }

  Future<void> _startCamera(CameraLensDirection direction) async {
    if (cameras == null || cameras!.isEmpty) return;

    CameraDescription? camera;
    try {
      camera = cameras!.firstWhere(
        (c) => c.lensDirection == direction,
      );
    } catch (e) {
      // If specific direction not found, use the first one
      if (cameras!.isNotEmpty) {
        camera = cameras!.first;
        currentDirection = camera.lensDirection;
      } else {
        return;
      }
    }

    await controller?.dispose();

    controller = CameraController(
      camera!, 
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await controller!.initialize();
    currentDirection = direction;
  }

  Future<void> switchCamera() async {
    final newDirection =
        currentDirection == CameraLensDirection.front
            ? CameraLensDirection.back
            : CameraLensDirection.front;

    await _startCamera(newDirection);
  }

  Future<XFile?> takePicture() async {
    if (controller == null || !controller!.value.isInitialized) return null;
    return await controller!.takePicture();
  }

  void dispose() {
    controller?.dispose();
  }
}
