// Lokasi: lib/widgets/face_points_painter.dart
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:jagamata/controllers/acupressure_controller.dart';

class FacePointsPainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final AcupressureController controller;

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
    final landmark = face.landmarks[currentPoint.landmarkType];

    if (landmark != null) {
      // Logic scaling untuk menyesuaikan koordinat gambar ke layar
      final double scaleX = size.width / imageSize.height;
      final double scaleY = size.height / imageSize.width;

      // Transformasi Koordinat (Mirroring & Scaling)
      // Kamera depan di Android biasanya perlu dibalik (width - x)
      double x = size.width - (landmark.position.x * scaleX);
      double y = landmark.position.y * scaleY;

      // Terapkan Offset manual
      x += (currentPoint.offsetX * scaleX);
      y += (currentPoint.offsetY * scaleY);

      // --- PERBAIKAN UKURAN DI SINI ---
      final Paint paint = Paint()
        ..color = Colors.greenAccent.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      final Paint borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2; // Penipisan garis batas

      // Radius dikecilkan agar proporsional
      canvas.drawCircle(
        Offset(x, y),
        6,
        paint,
      ); // Ukuran titik dalam (sebelumnya 15)
      canvas.drawCircle(
        Offset(x, y),
        10,
        borderPaint,
      ); // Ukuran ring luar (sebelumnya 18)
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
