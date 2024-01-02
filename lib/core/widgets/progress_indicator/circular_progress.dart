import 'package:flutter/material.dart';
import 'package:klikit/core/widgets/progress_indicator/circle_painter.dart';
import 'package:klikit/resources/colors.dart';

class CircularProgress extends StatefulWidget {
  final double size;
  final double strokeWidth;
  final Color? primaryColor;
  final Color? secondaryColor;
  final int lapDuration;

  /// You may pass default size of flutter circular progress indicator which is 36 for the param, [size]
  const CircularProgress({
    super.key,
    this.size = 36,
    this.strokeWidth = 6,
    this.primaryColor,
    this.secondaryColor,
    this.lapDuration = 1500,
  });

  @override
  State<CircularProgress> createState() => _CircularProgressState();
}

class _CircularProgressState extends State<CircularProgress> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: widget.lapDuration))..repeat();
    animation = Tween<double>(begin: 0.0, end: 360.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(
        begin: 0.0,
        end: 1.0,
      ).animate(controller),
      child: CustomPaint(
        painter: CirclePainter(
          secondaryColor: widget.secondaryColor ?? AppColors.white,
          primaryColor: widget.primaryColor ?? AppColors.primary,
          strokeWidth: widget.strokeWidth,
        ),
        size: Size(widget.size, widget.size),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
