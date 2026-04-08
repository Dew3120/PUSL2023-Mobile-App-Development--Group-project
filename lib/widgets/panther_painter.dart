import 'package:flutter/material.dart';

class PantherPainter extends CustomPainter {
  final Color color;

  const PantherPainter({required this.color});

  // Cartier Panthère — wide cat face, large clean polygons
  // Width: -85 to +85 | Height: -90 to +78
  static const List<List<Offset>> _polygons = [
    // ── LEFT EAR (points up-left) ──
    [Offset(-38, -90), Offset(-68, -62), Offset(-18, -62)],

    // ── RIGHT EAR (points up-right) ──
    [Offset(38, -90), Offset(68, -62), Offset(18, -62)],

    // ── TOP FOREHEAD CENTER ──
    [Offset(-18, -62), Offset(18, -62), Offset(12, -42), Offset(-12, -42)],

    // ── LEFT FOREHEAD ──
    [Offset(-68, -62), Offset(-18, -62), Offset(-12, -42), Offset(-42, -35)],

    // ── RIGHT FOREHEAD ──
    [Offset(68, -62), Offset(18, -62), Offset(12, -42), Offset(42, -35)],

    // ── LEFT UPPER CHEEK (large sweeping) ──
    [Offset(-68, -62), Offset(-42, -35), Offset(-82, -5)],

    // ── RIGHT UPPER CHEEK ──
    [Offset(68, -62), Offset(42, -35), Offset(82, -5)],

    // ── LEFT EYE SURROUND ──
    [Offset(-42, -35), Offset(-12, -42), Offset(-10, -12), Offset(-36, -8)],

    // ── RIGHT EYE SURROUND ──
    [Offset(42, -35), Offset(12, -42), Offset(10, -12), Offset(36, -8)],

    // ── NOSE BRIDGE (center between eyes) ──
    [Offset(-12, -42), Offset(12, -42), Offset(10, -12), Offset(-10, -12)],

    // ── LEFT MID CHEEK ──
    [Offset(-82, -5), Offset(-42, -35), Offset(-36, -8), Offset(-65, 25)],

    // ── RIGHT MID CHEEK ──
    [Offset(82, -5), Offset(42, -35), Offset(36, -8), Offset(65, 25)],

    // ── LEFT LOWER CHEEK ──
    [Offset(-65, 25), Offset(-36, -8), Offset(-10, -12), Offset(-8, 8), Offset(-26, 30)],

    // ── RIGHT LOWER CHEEK ──
    [Offset(65, 25), Offset(36, -8), Offset(10, -12), Offset(8, 8), Offset(26, 30)],

    // ── NOSE ──
    [Offset(-10, -12), Offset(10, -12), Offset(7, 8), Offset(-7, 8)],

    // ── LEFT MUZZLE ──
    [Offset(-26, 30), Offset(-8, 8), Offset(-7, 28), Offset(-18, 46)],

    // ── RIGHT MUZZLE ──
    [Offset(26, 30), Offset(8, 8), Offset(7, 28), Offset(18, 46)],

    // ── MUZZLE CENTER ──
    [Offset(-7, 8), Offset(7, 8), Offset(5, 28), Offset(-5, 28)],

    // ── LEFT JAW ──
    [Offset(-46, 50), Offset(-26, 30), Offset(-18, 46), Offset(-15, 62)],

    // ── RIGHT JAW ──
    [Offset(46, 50), Offset(26, 30), Offset(18, 46), Offset(15, 62)],

    // ── LEFT CHIN ──
    [Offset(-15, 62), Offset(-5, 28), Offset(0, 78)],

    // ── RIGHT CHIN ──
    [Offset(15, 62), Offset(5, 28), Offset(0, 78)],

    // ── CHIN CENTER ──
    [Offset(-5, 28), Offset(5, 28), Offset(0, 78)],
  ];

  // Small filled eye diamonds + nose tip
  static const List<List<Offset>> _filled = [
    // LEFT EYE
    [Offset(-34, -30), Offset(-16, -35), Offset(-14, -14), Offset(-32, -10)],

    // RIGHT EYE
    [Offset(34, -30), Offset(16, -35), Offset(14, -14), Offset(32, -10)],

    // NOSE TIP
    [Offset(-4, -2), Offset(4, -2), Offset(3, 7), Offset(-3, 7)],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Wide format — 170 x 170
    const double pantherW = 175.0;
    const double pantherH = 175.0;

    final scaleX = size.width / pantherW;
    final scaleY = size.height / pantherH;
    final scale = scaleX < scaleY ? scaleX : scaleY;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale, scale);

    for (final polygon in _polygons) {
      final path = Path()..moveTo(polygon[0].dx, polygon[0].dy);
      for (int i = 1; i < polygon.length; i++) {
        path.lineTo(polygon[i].dx, polygon[i].dy);
      }
      path.close();
      canvas.drawPath(path, strokePaint);
    }

    for (final polygon in _filled) {
      final path = Path()..moveTo(polygon[0].dx, polygon[0].dy);
      for (int i = 1; i < polygon.length; i++) {
        path.lineTo(polygon[i].dx, polygon[i].dy);
      }
      path.close();
      canvas.drawPath(path, fillPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(PantherPainter old) => old.color != color;
}
