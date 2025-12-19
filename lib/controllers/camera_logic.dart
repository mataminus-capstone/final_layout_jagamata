import 'package:camera/camera.dart';

class CameraLogic {
  CameraController? controller;
  List<CameraDescription>? cameras;

  Future<void> initCamera() async {
    cameras = await availableCameras();

    controller = CameraController(
      cameras![0], // kamera belakang
      ResolutionPreset.low,
      enableAudio: false,
    );

    await controller!.initialize();
  }

  Future<XFile> takePicture() async {
    if (controller == null || !controller!.value.isInitialized) {
      throw Exception("Camera belum siap");
    }
    return await controller!.takePicture();
  }

  void dispose() {
    controller?.dispose();
  }
}
