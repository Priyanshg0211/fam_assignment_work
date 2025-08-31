// lib/widgets/common/gradient_container.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/card_models.dart' as models;

class GradientContainer extends StatelessWidget {
  final models.Gradient gradient;
  final Widget child;

  const GradientContainer({
    super.key,
    required this.gradient,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradient.colors
              .map((color) => Color(int.parse(color.replaceFirst('#', '0xFF'))))
              .toList(),
          begin: _getAlignmentFromAngle(gradient.angle),
          end: _getAlignmentFromAngle(gradient.angle + 180),
        ),
      ),
      child: child,
    );
  }

  Alignment _getAlignmentFromAngle(int angle) {
    double radians = (angle * math.pi) / 180;
    return Alignment(
      math.cos(radians),
      math.sin(radians),
    );
  }
}