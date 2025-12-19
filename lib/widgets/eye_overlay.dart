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
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final y = size.height * 0.4;

    canvas.drawCircle(Offset(size.width * 0.35, y), 30, paint);
    canvas.drawCircle(Offset(size.width * 0.65, y), 30, paint);

    canvas.drawLine(
      Offset(size.width * 0.25, y),
      Offset(size.width * 0.75, y),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
