import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:jagamata/services/camera_service.dart';
import 'package:jagamata/widgets/eye_overlay.dart';


class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  final CameraService _cameraService = CameraService();
  bool ready = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  String? errorMessage;

  Future<void> initCamera() async {
    try {
      await _cameraService.init();
      if (mounted) {
        setState(() => ready = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => errorMessage = "Gagal membuka kamera: $e");
      }
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: Text("Kamera Error")),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(errorMessage!, textAlign: TextAlign.center),
        )),
      );
    }

    if (!ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isFront =
        _cameraService.currentDirection == CameraLensDirection.front;

    return Scaffold(
      body: Stack(
        children: [
          Transform(
            alignment: Alignment.center,
            transform:
                isFront ? Matrix4.rotationY(3.14159) : Matrix4.identity(),
            child: CameraPreview(_cameraService.controller!),
          ),

          const EyeGuideOverlay(),

          Positioned(
            top: 40,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.cameraswitch,
                  color: Colors.white, size: 32),
              onPressed: () async {
                await _cameraService.switchCamera();
                setState(() {});
              },
            ),
          ),

          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                onPressed: () async {
                  final photo = await _cameraService.takePicture();
                  if (photo != null && context.mounted) {
                    Navigator.pop(context, photo.path);
                  }
                },
                child: const Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
