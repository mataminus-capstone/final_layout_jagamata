// Lokasi: lib/pages/acupressure_page.dart
import 'dart:io';
import 'dart:typed_data'; // Penting untuk Uint8List
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Penting untuk DeviceOrientation
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// Import file controller & widget (pastikan path ini benar sesuai project Anda)
import 'package:jagamata/controllers/acupressure_controller.dart';
import 'package:jagamata/widgets/face_points_painter.dart';

class AcupressurePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  
  const AcupressurePage({super.key, required this.cameras});

  @override
  State<AcupressurePage> createState() => _AcupressurePageState();
}

class _AcupressurePageState extends State<AcupressurePage> {
  CameraController? _cameraController; 
  late FaceDetector _faceDetector;
  final AcupressureController _logicController = AcupressureController();
  
  bool _isDetecting = false;
  List<Face> _faces = [];

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true, 
        enableContours: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  Future<void> _initializeCamera() async {
    if (widget.cameras.isEmpty) return;

    final frontCamera = widget.cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => widget.cameras.first,
    );

    final controller = CameraController(
      frontCamera,
      ResolutionPreset.high, // Ubah ke High agar gambar lebih tajam
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid 
          ? ImageFormatGroup.nv21 
          : ImageFormatGroup.bgra8888,
    );

    try {
      await controller.initialize();
      if (!mounted) return;
      await controller.startImageStream(_processCameraImage);

      setState(() {
        _cameraController = controller;
      });
    } catch (e) {
      debugPrint("Error initializing camera: $e");
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (_isDetecting || !mounted) return;
    _isDetecting = true;

    final inputImage = _inputImageFromCameraImage(image);
    if (inputImage == null) {
      _isDetecting = false;
      return;
    }

    try {
      final faces = await _faceDetector.processImage(inputImage);
      if (mounted) {
        setState(() {
          _faces = faces;
        });
      }
    } catch (e) {
      debugPrint("Error deteksi wajah: $e");
    } finally {
      _isDetecting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final size = MediaQuery.of(context).size;
    
    // --- RUMUS AGAR TIDAK LONJONG ---
    // Kita hitung scale factor untuk melakukan "Cover" pada layar
    // Tanpa merusak aspect ratio asli kamera
    var scale = size.aspectRatio * _cameraController!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand, // Stack utama memenuhi layar
        children: [
          // 1. LAYER VISUAL (Kamera + Titik)
          // Kita membungkus Kamera DAN Painter dalam Transform yang sama
          // Agar posisi titik tetap akurat menempel di wajah saat di-zoom
          Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: Stack(
              children: [
                Center(
                  child: CameraPreview(_cameraController!),
                ),
                Center(
                  child: AnimatedBuilder(
                    animation: _logicController,
                    builder: (context, _) {
                      return CustomPaint(
                        size: Size.infinite, // Painter mengikuti ukuran parent
                        painter: FacePointsPainter(
                          faces: _faces,
                          imageSize: _cameraController!.value.previewSize!,
                          controller: _logicController,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 2. LAYER UI (Tombol & Teks)
          // Layer ini TIDAK di-scale, agar tombol tetap di posisi wajar
          // Tombol Kembali
          Positioned(
            top: 50, 
            left: 20, 
            child: CircleAvatar(
              backgroundColor: Colors.black45,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Panel Bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildControlPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      color: Colors.black87.withOpacity(0.8),
      padding: const EdgeInsets.all(20),
      child: AnimatedBuilder(
        animation: _logicController,
        builder: (context, _) {
          if (_logicController.isFinished) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 50),
                const SizedBox(height: 10),
                const Text("Terapi Selesai!", style: TextStyle(color: Colors.white, fontSize: 20)),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _logicController.startSession,
                  child: const Text("Ulangi"),
                )
              ],
            );
          }

          if (!_logicController.isActive) {
            return ElevatedButton(
              onPressed: _logicController.startSession,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Colors.blueAccent
              ),
              child: const Text("Mulai Terapi Mata", style: TextStyle(color: Colors.white)),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _logicController.currentPoint.title,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                _logicController.currentPoint.instruction,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 15),
              LinearProgressIndicator(
                value: _logicController.secondsLeft / 10,
                color: Colors.blueAccent,
                backgroundColor: Colors.grey,
                minHeight: 6,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${_logicController.secondsLeft} Detik",
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;

    final camera = widget.cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => widget.cameras.first,
    );

    final sensorOrientation = camera.sensorOrientation;
    
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[_cameraController!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    
    rotation = rotation ?? InputImageRotation.rotation270deg;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    
    if (format == null || 
        (Platform.isAndroid && format != InputImageFormat.nv21) || 
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
          return null;
    }

    if (image.planes.isEmpty) return null;
    
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    _logicController.dispose();
    super.dispose();
  }
}