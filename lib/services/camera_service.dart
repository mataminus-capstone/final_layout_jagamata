import 'package:camera/camera.dart';

class CameraService {
  CameraController? controller;
  List<CameraDescription>? cameras;
  CameraLensDirection currentDirection = CameraLensDirection.front;

  Future<void> init() async {
    cameras = await availableCameras();
    await _startCamera(currentDirection);
  }

  Future<void> _startCamera(CameraLensDirection direction) async {
    final camera = cameras!.firstWhere(
      (c) => c.lensDirection == direction,
    );

    await controller?.dispose();

    controller = CameraController(
      camera,
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
    if (!controller!.value.isInitialized) return null;
    return await controller!.takePicture();
  }

  void dispose() {
    controller?.dispose();
  }
}
