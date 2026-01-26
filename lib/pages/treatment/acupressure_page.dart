// Lokasi: lib/pages/treatment/acupressure_page.dart
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

// Import controller, model & widget
import 'package:jagamata/controllers/acupressure_controller.dart';
import 'package:jagamata/models/acupressure_model.dart';
import 'package:jagamata/widgets/face_points_painter.dart';

class AcupressurePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final EyeCondition? eyeCondition; // Parameter untuk kondisi mata (opsional)

  const AcupressurePage({
    super.key,
    required this.cameras,
    this.eyeCondition, // Default null untuk backward compatibility
  });

  @override
  State<AcupressurePage> createState() => _AcupressurePageState();
}

class _AcupressurePageState extends State<AcupressurePage> {
  CameraController? _cameraController;
  late FaceDetector _faceDetector;
  late AcupressureController _logicController;

  bool _isDetecting = false;
  List<Face> _faces = [];

  // Colors
  final Color kDarkBlue = const Color(0xFF11417f);
  final Color kLightBlue = const Color(0xFF14b4ef);
  final Color kTosca = const Color(0xFFa2c38e);
  final Color kOrange = const Color(0xFFff7043);

  @override
  void initState() {
    super.initState();

    // Initialize controller dan set kondisi
    _logicController = AcupressureController();
    if (widget.eyeCondition != null) {
      _logicController.setCondition(widget.eyeCondition!);
    }

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
      ResolutionPreset.high,
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
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: kLightBlue),
              const SizedBox(height: 16),
              Text(
                "Mempersiapkan kamera...",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _cameraController!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // LAYER VISUAL (Kamera + Titik)
          Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: Stack(
              children: [
                Center(child: CameraPreview(_cameraController!)),
                Center(
                  child: AnimatedBuilder(
                    animation: _logicController,
                    builder: (context, _) {
                      return CustomPaint(
                        size: Size.infinite,
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

          // LAYER UI - Header
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black45,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                // Kondisi Badge
                AnimatedBuilder(
                  animation: _logicController,
                  builder: (context, _) {
                    final isFatigued =
                        _logicController.condition == EyeCondition.fatigued;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isFatigued
                            ? kOrange.withOpacity(0.9)
                            : kTosca.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isFatigued
                                ? Icons.warning_amber_rounded
                                : Icons.check_circle,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isFatigued ? "Indikasi Lelah" : "Kondisi Baik",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // LAYER UI - Control Panel
          Positioned(bottom: 0, left: 0, right: 0, child: _buildControlPanel()),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
      ),
      padding: const EdgeInsets.all(20),
      child: AnimatedBuilder(
        animation: _logicController,
        builder: (context, _) {
          // LAYAR MULAI
          if (!_logicController.isActive && !_logicController.isFinished) {
            return _buildStartScreen();
          }

          // LAYAR SELESAI
          if (_logicController.isFinished) {
            return _buildFinishScreen();
          }

          // LAYAR AKTIF
          return _buildActiveScreen();
        },
      ),
    );
  }

  Widget _buildStartScreen() {
    final isFatigued = _logicController.condition == EyeCondition.fatigued;
    final config = _logicController.config;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Info Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white24),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    isFatigued ? Icons.spa : Icons.self_improvement,
                    color: isFatigued ? kOrange : kTosca,
                    size: 30,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isFatigued
                              ? "Terapi Indikasi Lelah"
                              : "Terapi Maintenance",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          config.description,
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    icon: Icons.touch_app,
                    label: "${_logicController.totalPoints} Titik",
                  ),
                  _buildStatItem(
                    icon: Icons.timer,
                    label: "${config.durationPerPoint} Detik/Titik",
                  ),
                  _buildStatItem(
                    icon: Icons.repeat,
                    label: "${config.repetitions}x Ulang",
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Pressure level
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isFatigued
                      ? kOrange.withOpacity(0.2)
                      : kTosca.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.compress,
                      color: isFatigued ? kOrange : kTosca,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Tekanan: ${config.pressureLevel}",
                      style: TextStyle(
                        color: isFatigued ? kOrange : kTosca,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Start Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _logicController.startSession,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: isFatigued ? kOrange : kTosca,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_arrow, color: Colors.white),
                const SizedBox(width: 8),
                const Text(
                  "Mulai Terapi Mata",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({required IconData icon, required String label}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white54, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildFinishScreen() {
    final isFatigued = _logicController.condition == EyeCondition.fatigued;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kTosca.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_circle, color: kTosca, size: 60),
        ),
        const SizedBox(height: 16),
        const Text(
          "Terapi Selesai! 🎉",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isFatigued
              ? "Istirahatkan mata Anda sejenak. Jangan lupa berkedip!"
              : "Mata Anda tetap sehat. Pertahankan kebiasaan baik!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _logicController.resetSession,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: Colors.white54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Ulangi",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: kTosca,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Selesai",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveScreen() {
    final isFatigued = _logicController.condition == EyeCondition.fatigued;
    final config = _logicController.config;
    final progress = _logicController.secondsLeft / config.durationPerPoint;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with progress and pause
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Point counter
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Titik ${_logicController.currentPointIndex}/${_logicController.totalPoints}",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
            // Repetition counter (if applicable)
            if (config.repetitions > 1)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: kOrange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Ulangan ${_logicController.currentRepetition}/${config.repetitions}",
                  style: TextStyle(
                    color: kOrange,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // Pause button
            IconButton(
              icon: Icon(
                _logicController.isActive
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_filled,
                color: Colors.white,
                size: 36,
              ),
              onPressed: _logicController.isActive
                  ? _logicController.pauseSession
                  : _logicController.resumeSession,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Point Info Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Point code and name
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isFatigued ? kOrange : kTosca,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _logicController.currentPoint.code,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _logicController.currentPoint.chineseName,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Point title
              Text(
                _logicController.currentPoint.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              // Description
              Text(
                _logicController.currentPoint.description,
                style: TextStyle(
                  color: isFatigued ? kOrange : kTosca,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              // Instruction
              Text(
                _logicController.currentPoint.instruction,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            color: isFatigued ? kOrange : kTosca,
            backgroundColor: Colors.white24,
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 10),

        // Countdown
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Tekanan: ${config.pressureLevel}",
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isFatigued ? kOrange : kTosca,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${_logicController.secondsLeft} Detik",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
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
      var rotationCompensation =
          _orientations[_cameraController!.value.deviceOrientation];
      if (rotationCompensation == null) return null;

      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
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
