import 'package:flutter/material.dart';

class OutfitLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final Color outlineColor = const Color(0xFF5D4037);
    final Color fabricColor = const Color(0xFFFAFAFA);

    final mainPaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.008
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final detailPaint = Paint()
      ..color = outlineColor.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.005
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = fabricColor
      ..style = PaintingStyle.fill;

    final mannequinPath = Path();
    mannequinPath.addOval(Rect.fromCenter(center: Offset(w * 0.5, h * 0.05), width: w * 0.06, height: w * 0.04));
    mannequinPath.moveTo(w * 0.485, h * 0.07);
    mannequinPath.lineTo(w * 0.485, h * 0.12);
    mannequinPath.moveTo(w * 0.515, h * 0.07);
    mannequinPath.lineTo(w * 0.515, h * 0.12);

    mannequinPath.moveTo(w * 0.44, h * 0.12);
    mannequinPath.quadraticBezierTo(w * 0.5, h * 0.14, w * 0.56, h * 0.12);
    mannequinPath.lineTo(w * 0.56, h * 0.09);
    mannequinPath.quadraticBezierTo(w * 0.5, h * 0.11, w * 0.44, h * 0.09);
    mannequinPath.close();

    canvas.drawPath(mannequinPath, mainPaint..style = PaintingStyle.fill..color = const Color(0xFFD7CCC8));
    canvas.drawPath(mannequinPath, mainPaint..style = PaintingStyle.stroke..color = outlineColor);

    final dressPath = Path();
    dressPath.moveTo(w * 0.38, h * 0.24);

    dressPath.cubicTo(w * 0.38, h * 0.24, w * 0.42, h * 0.18, w * 0.50, h * 0.26);
    dressPath.cubicTo(w * 0.58, h * 0.18, w * 0.62, h * 0.24, w * 0.62, h * 0.24);

    dressPath.cubicTo(w * 0.61, h * 0.32, w * 0.58, h * 0.38, w * 0.56, h * 0.42);

    dressPath.cubicTo(w * 0.75, h * 0.55, w * 0.85, h * 0.70, w * 0.92, h * 0.88);

    dressPath.quadraticBezierTo(w * 0.85, h * 0.92, w * 0.80, h * 0.85);
    dressPath.quadraticBezierTo(w * 0.75, h * 0.95, w * 0.65, h * 0.90);
    dressPath.quadraticBezierTo(w * 0.55, h * 0.98, w * 0.50, h * 0.92);
    dressPath.quadraticBezierTo(w * 0.40, h * 0.98, w * 0.30, h * 0.90);
    dressPath.quadraticBezierTo(w * 0.15, h * 0.94, w * 0.08, h * 0.88);

    dressPath.cubicTo(w * 0.15, h * 0.70, w * 0.25, h * 0.55, w * 0.44, h * 0.42);

    dressPath.cubicTo(w * 0.42, h * 0.38, w * 0.39, h * 0.32, w * 0.38, h * 0.24);

    canvas.drawPath(dressPath, fillPaint);
    canvas.drawPath(dressPath, mainPaint);

    final corsetLines = Path();
    corsetLines.moveTo(w * 0.50, h * 0.26);
    corsetLines.lineTo(w * 0.50, h * 0.43);

    corsetLines.moveTo(w * 0.44, h * 0.23);
    corsetLines.quadraticBezierTo(w * 0.45, h * 0.35, w * 0.46, h * 0.42);

    corsetLines.moveTo(w * 0.56, h * 0.23);
    corsetLines.quadraticBezierTo(w * 0.55, h * 0.35, w * 0.54, h * 0.42);

    corsetLines.moveTo(w * 0.44, h * 0.42);
    corsetLines.quadraticBezierTo(w * 0.50, h * 0.44, w * 0.56, h * 0.42);

    canvas.drawPath(corsetLines, detailPaint);

    final foldPaint = Paint()
      ..color = outlineColor.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.003
      ..strokeCap = StrokeCap.round;

    final folds = Path();
    folds.moveTo(w * 0.45, h * 0.43);
    folds.quadraticBezierTo(w * 0.30, h * 0.60, w * 0.30, h * 0.90);

    folds.moveTo(w * 0.55, h * 0.43);
    folds.quadraticBezierTo(w * 0.70, h * 0.60, w * 0.80, h * 0.85);

    folds.moveTo(w * 0.50, h * 0.44);
    folds.lineTo(w * 0.50, h * 0.85);

    canvas.drawPath(folds, foldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
