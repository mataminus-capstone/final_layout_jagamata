// Lokasi: lib/widgets/face_points_painter.dart
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:jagamata/models/acupressure_model.dart';
import 'package:jagamata/controllers/acupressure_controller.dart';

class FacePointsPainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final AcupressureController controller;

  // Colors
  static const Color kTosca = Color(0xFFa2c38e);
  static const Color kOrange = Color(0xFFff7043);

  FacePointsPainter({
    required this.faces,
    required this.imageSize,
    required this.controller,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (faces.isEmpty || !controller.isActive) return;

    final Face face = faces.first;
    final currentPoint = controller.currentPoint;
    final isFatigued = controller.condition == EyeCondition.fatigued;

    // Point color based on eye condition
    final Color pointColor = isFatigued ? kOrange : kTosca;

    void drawPoint(
      FaceLandmarkType landmarkType,
      double offsetX,
      double offsetY, {
      required bool isLeftEye,
    }) {
      final landmark = face.landmarks[landmarkType];
      if (landmark != null) {
        final double scaleX = size.width / imageSize.height;
        final double scaleY = size.height / imageSize.width;

        // NON-MIRROR UNTUK TITIK (biar sesuai instruksi)
        double x = landmark.position.x * scaleX;
        double y = landmark.position.y * scaleY;

        x += (offsetX * scaleX);
        y += (offsetY * scaleY);

        // Outer glow effect
        final Paint glowPaint = Paint()
          ..color = pointColor.withAlpha(80)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

        // Main point
        final Paint pointPaint = Paint()
          ..color = pointColor
          ..style = PaintingStyle.fill;

        // Border
        final Paint borderPaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5;

        // Inner highlight
        final Paint highlightPaint = Paint()
          ..color = Colors.white.withAlpha(150)
          ..style = PaintingStyle.fill;

        // Draw layers
        canvas.drawCircle(Offset(x, y), 20, glowPaint); // Glow
        canvas.drawCircle(Offset(x, y), 10, pointPaint); // Main point
        canvas.drawCircle(Offset(x, y), 10, borderPaint); // Border
        canvas.drawCircle(
          Offset(x - 2, y - 2),
          3,
          highlightPaint,
        ); // Inner highlight

        // Draw point code text
        final textPainter = TextPainter(
          text: TextSpan(
            text: currentPoint.code,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  blurRadius: 4,
                  color: Colors.black54,
                  offset: Offset(1, 1),
                ),
              ],
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(x - textPainter.width / 2, y + 15));
      }
    }

    // Draw point for current eye side
    if (currentPoint.side == EyeSide.left) {
      drawPoint(
        currentPoint.landmarkType,
        currentPoint.offsetX,
        currentPoint.offsetY,
        isLeftEye: true,
      );
    } else if (currentPoint.side == EyeSide.right) {
      drawPoint(
        currentPoint.landmarkType,
        currentPoint.offsetX,
        currentPoint.offsetY,
        isLeftEye: false,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
