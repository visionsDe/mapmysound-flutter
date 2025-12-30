import 'package:flutter/material.dart';

class RectangularThumbShape extends SliderComponentShape {
  const RectangularThumbShape({
    this.enabledThumbRadius = 12.0,
  });

  final double enabledThumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size(enabledThumbRadius * 2, enabledThumbRadius);

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
        required Animation<double> enableAnimation,
        required bool isDiscrete,
        required TextPainter labelPainter,
        required RenderBox parentBox,
        required SliderThemeData sliderTheme,
        required TextDirection textDirection,
        required double value,
        required double textScaleFactor,
        required Size sizeWithOverflow}) {
    final bool enabled = enableAnimation.value > 0.5;
    final Color color = enabled
        ? sliderTheme.thumbColor!
        : sliderTheme.disabledThumbColor!;

    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw rectangle (width: 24px, height: 12px, rounded corners)
    final Rect rect = Rect.fromCenter(
      center: center,
      width: 24.0,
      height: 12.0,
    );
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(3.0)),
      paint,
    );
  }
}

