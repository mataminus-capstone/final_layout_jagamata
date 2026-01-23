import 'package:flutter/material.dart';

class EyeGuideOverlay extends StatelessWidget {
  const EyeGuideOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: MediaQuery.of(context).size,
        painter: _EyeGuidePainter(),
      ),
    );
  }
}

class _EyeGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Posisi di tengah layar, sedikit ke atas
    final centerX = size.width / 2;
    final centerY = size.height * 0.35;
    final eyeRadius = 40.0;

    // ============================
    // VARIAN 1: SIMPLE CIRCLE + PUPIL
    // ============================
    // Outline mata (lingkaran besar)
    canvas.drawCircle(Offset(centerX, centerY), eyeRadius, paint);

    // Pupil (titik kecil di tengah)
    final pupilPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), 8, pupilPaint);

    // ============================
    // VARIAN 2: MATA DENGAN KELIPAK (UNGKOMEN JIKA INGIN)
    // ============================
    final path = Path();
    path.moveTo(centerX - eyeRadius * 0.7, centerY - eyeRadius * 0.2);
    path.quadraticBezierTo(
      centerX, centerY - eyeRadius * 0.9,
      centerX + eyeRadius * 0.7, centerY - eyeRadius * 0.2,
    );
    canvas.drawPath(path, paint);

    // ============================
    // VARIAN 3: MATA BERKELIP (Animasi) - Bisa ditambahkan nanti
    // ============================
    // Tambahkan AnimatedBuilder di widget parent
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
