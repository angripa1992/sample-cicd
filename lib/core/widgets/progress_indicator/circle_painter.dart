import 'dart:math' as math;

import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final double strokeWidth;

  CirclePainter({
    super.repaint,
    required this.primaryColor,
    required this.secondaryColor,
    required this.strokeWidth,
  });

  double _degreeToRad(double degree) => degree * math.pi / 180;

  @override
  void paint(Canvas canvas, Size size) {
    double centerPoint = size.height / 2;

    Paint paint = Paint()
      ..color = primaryColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    paint.shader = SweepGradient(
      colors: [secondaryColor, primaryColor],
      tileMode: TileMode.repeated,
      startAngle: _degreeToRad(270),
      endAngle: _degreeToRad(270 + 360.0),
    ).createShader(Rect.fromCircle(center: Offset(centerPoint, centerPoint), radius: 0));

    var scapSize = strokeWidth * 0.70;
    double scapToDegree = scapSize / centerPoint;

    double startAngle = _degreeToRad(270) + scapToDegree;
    double sweepAngle = _degreeToRad(360) - (2 * scapToDegree);

    canvas.drawArc(const Offset(0.0, 0.0) & Size(size.width, size.width), startAngle, sweepAngle, false, paint..color = primaryColor);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
