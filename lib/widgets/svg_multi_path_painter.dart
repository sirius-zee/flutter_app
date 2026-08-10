import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/svg_path_data.dart';

class SvgMultiPathPainter extends CustomPainter {
  final List<SvgPathData> pathList;
  final Rect totalBounds;
  final double strokeProgress;
  final double fillProgress;
  final double strokeWidth;

  SvgMultiPathPainter({
    required this.pathList,
    required this.totalBounds,
    required this.strokeProgress,
    required this.fillProgress,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (totalBounds.width == 0 || totalBounds.height == 0) return;

    double scaleX = size.width / totalBounds.width;
    double scaleY = size.height / totalBounds.height;
    double scale = scaleX < scaleY ? scaleX : scaleY;

    Matrix4 matrix = Matrix4.identity();
    matrix.scaleByDouble(scale, scale, 1.0, 1.0);
    matrix.translateByDouble(-totalBounds.left, -totalBounds.top, 0.0, 1.0);

    for (var item in pathList) {
      Path scaledPath = item.path.transform(matrix.storage);

      // 1. Gambar Isian (Fill)
      if (fillProgress > 0 && item.fillColor != Colors.transparent) {
        Paint fillPaint = Paint()
          ..color = item.fillColor.withValues(
            alpha: item.fillColor.a * fillProgress,
          )
          ..style = PaintingStyle.fill;

        canvas.drawPath(scaledPath, fillPaint);
      }

      // 2. Gambar Garis (Stroke)
      if (item.strokeColor != Colors.transparent) {
        Paint strokePaint = Paint()
          ..color = item.strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round;

        Path drawnPath = Path();
        for (PathMetric pathMetric in scaledPath.computeMetrics()) {
          double extractLength = pathMetric.length * strokeProgress;
          drawnPath.addPath(
            pathMetric.extractPath(0.0, extractLength),
            Offset.zero,
          );
        }

        canvas.drawPath(drawnPath, strokePaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SvgMultiPathPainter oldDelegate) {
    return oldDelegate.strokeProgress != strokeProgress ||
        oldDelegate.fillProgress != fillProgress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.pathList != pathList;
  }
}
