import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class MiniBarChart extends StatelessWidget {
  const MiniBarChart({
    super.key,
    required this.values,
    required this.labels,
    this.height = 160,
    this.color = AppColors.primary,
  });

  final List<double> values;
  final List<String> labels;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: _BarPainter(values: values, color: color),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 0; i < labels.length; i++)
              Expanded(
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.inkMuted,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxVal = values.reduce(math.max);
    final maximo = maxVal <= 0 ? 1.0 : maxVal;
    final gridPaint = Paint()
      ..color = AppColors.border
      ..strokeWidth = 1;
    const top = 22.0;
    final alto = size.height - top;

    for (var i = 0; i <= 3; i++) {
      final y = top + (alto / 3) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final slot = size.width / values.length;
    final barWidth = slot * 0.44;

    for (var i = 0; i < values.length; i++) {
      final centro = slot * i + slot / 2;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(centro - barWidth / 2, top, barWidth, alto),
        const Radius.circular(8),
      );
      canvas.drawRRect(
        rect,
        Paint()..color = color.withValues(alpha: 0.07),
      );

      final proporcion = (values[i] / maximo).clamp(0.0, 1.0);
      final barHeight = values[i] <= 0 ? 6.0 : math.max(8.0, alto * proporcion);
      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centro - barWidth / 2,
          top + alto - barHeight,
          barWidth,
          barHeight,
        ),
        const Radius.circular(8),
      );
      final paint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            color,
            color.withValues(alpha: 0.55),
          ],
        ).createShader(barRect.outerRect);
      canvas.drawRRect(barRect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}

class DonutChart extends StatelessWidget {
  const DonutChart({
    super.key,
    required this.values,
    required this.colors,
    this.size = 168,
    this.centerValue,
    this.centerLabel,
  });

  final List<double> values;
  final List<Color> colors;
  final double size;
  final String? centerValue;
  final String? centerLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(size, size),
            painter: _DonutPainter(values: values, colors: colors),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (centerValue != null)
                Text(
                  centerValue!,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                    color: AppColors.ink,
                  ),
                ),
              if (centerLabel != null)
                Text(
                  centerLabel!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkMuted,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.values, required this.colors});

  final List<double> values;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold(0.0, (sum, value) => sum + value);
    final stroke = size.width * 0.13;
    final rect = Rect.fromCircle(
      center: size.center(Offset.zero),
      radius: (size.width - stroke) / 2,
    );
    final fondo = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..color = AppColors.border;

    if (total <= 0) {
      canvas.drawArc(rect, 0, math.pi * 2, false, fondo);
      return;
    }

    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      final sweep = (values[i] / total) * math.pi * 2;
      if (sweep <= 0) continue;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round
        ..color = colors[i % colors.length];
      final gap = values.length > 1 ? 0.05 : 0.0;
      canvas.drawArc(rect, start + gap, math.max(0.01, sweep - gap * 2), false, paint);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.colors != colors;
}
