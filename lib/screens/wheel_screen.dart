import 'dart:math';
import 'package:flutter/material.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({super.key});

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _spinAnimation;

  bool _isSpinning = false;
  bool _hasSpun = false;
  double _currentAngle = 0;
  int _winningIndex = 0;

  static const _segments = [
    _Segment('FREE\nSHIPPING', Icons.local_shipping_outlined),
    _Segment('£50\nOFF', Icons.sell_outlined),
    _Segment('10%\nOFF', Icons.percent),
    _Segment('EARLY\nACCESS', Icons.star_outline),
    _Segment('15%\nOFF', Icons.percent),
    _Segment('£25\nOFF', Icons.sell_outlined),
    _Segment('SALE\nACCESS', Icons.shopping_bag_outlined),
    _Segment('GIFT\nWRAP', Icons.card_giftcard_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spin() {
    if (_isSpinning || _hasSpun) return;

    _winningIndex = Random().nextInt(_segments.length);

    // Target angle: spin 6 full rotations + land on winning segment
    final segmentAngle = (2 * pi) / _segments.length;
    // The winning segment should face the top indicator
    final winningCenter = _winningIndex * segmentAngle + segmentAngle / 2;
    final targetAngle =
        _currentAngle + (6 * 2 * pi) + ((2 * pi - winningCenter % (2 * pi)));

    _spinAnimation = Tween<double>(
      begin: _currentAngle,
      end: targetAngle,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.decelerate,
    ));

    setState(() => _isSpinning = true);

    _controller.forward(from: 0).then((_) {
      _currentAngle = targetAngle;
      setState(() {
        _isSpinning = false;
        _hasSpun = true;
      });
      _showResult();
    });
  }

  void _showResult() {
    final segment = _segments[_winningIndex];
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFFD50032),
                  shape: BoxShape.circle,
                ),
                child: Icon(segment.icon, color: Colors.white, size: 32),
              ),
              const SizedBox(height: 20),
              const Text(
                'CONGRATULATIONS',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 3,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFD50032),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You won ${segment.label.replaceAll('\n', ' ')}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Your exclusive reward has been added to your account. Use it on your next order.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.pop(context); // close wheel screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  child: const Text(
                    'START SHOPPING',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            //  Header 
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  const Text(
                    'YOUR EXCLUSIVE REWARD',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 3,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFD50032),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Spin to Win!',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5,
                      fontFamily: 'Basis',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You have an exclusive reward waiting today.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            //  Wheel 
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Indicator triangle
                  const _Indicator(),

                  // Wheel
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: AnimatedBuilder(
                      animation: _isSpinning ? _spinAnimation : kAlwaysCompleteAnimation,
                      builder: (context, _) {
                        final angle = _isSpinning
                            ? _spinAnimation.value
                            : _currentAngle;
                        return Transform.rotate(
                          angle: angle,
                          child: CustomPaint(
                            size: Size(
                              MediaQuery.of(context).size.width - 48,
                              MediaQuery.of(context).size.width - 48,
                            ),
                            painter: _WheelPainter(segments: _segments),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            //  Buttons 
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: (_isSpinning || _hasSpun) ? null : _spin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD50032),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey[300],
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  child: const Text(
                    'SPIN THE WHEEL',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),
            ),

            TextButton(
              onPressed:
                  _isSpinning ? null : () => Navigator.pop(context),
              child: Text(
                'Maybe later',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[500],
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.grey[400],
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

//  Segment data 

class _Segment {
  final String label;
  final IconData icon;
  const _Segment(this.label, this.icon);
}

//  Indicator triangle 

class _Indicator extends StatelessWidget {
  const _Indicator();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(painter: _TrianglePainter()),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

//  Wheel painter 

class _WheelPainter extends CustomPainter {
  final List<_Segment> segments;
  const _WheelPainter({required this.segments});

  static const _colors = [
    Color(0xFFD50032),
    Color(0xFF8B001F),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = (2 * pi) / segments.length;

    for (int i = 0; i < segments.length; i++) {
      final startAngle = -pi / 2 + i * segmentAngle;

      //  Segment fill 
      final fill = Paint()
        ..color = _colors[i % _colors.length]
        ..style = PaintingStyle.fill;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        fill,
      );

      //  Divider line 
      final line = Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        center,
        Offset(
          center.dx + radius * cos(startAngle),
          center.dy + radius * sin(startAngle),
        ),
        line,
      );

      //  Label text 
      final textAngle = startAngle + segmentAngle / 2;
      final textRadius = radius * 0.62;
      final textCenter = Offset(
        center.dx + textRadius * cos(textAngle),
        center.dy + textRadius * sin(textAngle),
      );

      canvas.save();
      canvas.translate(textCenter.dx, textCenter.dy);
      canvas.rotate(textAngle + pi / 2);

      final tp = TextPainter(
        text: TextSpan(
          text: segments[i].label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            height: 1.4,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: 70);

      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }

    //  Outer ring 
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    //  Centre circle 
    canvas.drawCircle(center, radius * 0.17,
        Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      radius * 0.17,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    final spinTp = TextPainter(
      text: const TextSpan(
        text: 'SPIN',
        style: TextStyle(
          color: Colors.black,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout();
    spinTp.paint(
      canvas,
      Offset(center.dx - spinTp.width / 2, center.dy - spinTp.height / 2),
    );
  }

  @override
  bool shouldRepaint(_WheelPainter old) => old.segments != segments;
}
