import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final double heightFactor;

  const GradientBackground({
    super.key,
    required this.child,
    this.heightFactor = 0.45,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * heightFactor,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF38A1EB), Color(0xFF0077C9)],
              ),
            ),
            child: Stack(
              children: [
                // Pattern overlay
                Opacity(
                  opacity: 0.15,
                  child: CustomPaint(
                    painter: DotPatternPainter(),
                    size: Size.infinite,
                  ),
                ),
                // Blobs
                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    width: 192,
                    height: 192,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  left: -20,
                  child: Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[400]!.withOpacity(0.2),
                    ),
                  ),
                ),
                // Header Content
                child,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class DotPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    const double spacing = 20.0;
    const double radius = 1.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
