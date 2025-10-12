import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw a simple spiral-like swirl
    for (double i = 0; i < 4; i += 0.1) {
      double angle = i * 2 * 3.1415;
      double r = radius * i / 4;
      double x = center.dx + r * cos(angle);
      double y = center.dy + r * sin(angle);
      canvas.drawCircle(Offset(x, y), 1, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}