// lib/widgets/splash/splash_background.dart
import 'package:flutter/material.dart';

class SplashBackground extends StatelessWidget {
  final bool isDark;
  final Widget child;

  const SplashBackground({
    Key? key,
    required this.isDark,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: _buildGradient(),
      ),
      child: Stack(
        children: [
          // Animated background elements
          _buildBackgroundElements(),
          // Main content
          child,
        ],
      ),
    );
  }

  LinearGradient _buildGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
        const Color(0xFF0D47A1), // Deep blue
        const Color(0xFF1565C0), // Medium blue
        const Color(0xFF1976D2), // Primary blue
        const Color(0xFF0D47A1), // Deep blue
      ]
          : [
        const Color(0xFF1976D2), // Primary blue
        const Color(0xFF1565C0), // Medium blue
        const Color(0xFF0D47A1), // Deep blue
        const Color(0xFF0A3D91), // Darker blue
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );
  }

  Widget _buildBackgroundElements() {
    return Stack(
      children: [
        // Floating circles/bubbles
        Positioned(
          top: 100,
          right: -50,
          child: _buildFloatingCircle(120, Colors.white.withOpacity(0.1)),
        ),
        Positioned(
          top: 300,
          left: -30,
          child: _buildFloatingCircle(80, Colors.white.withOpacity(0.08)),
        ),
        Positioned(
          bottom: 200,
          right: 50,
          child: _buildFloatingCircle(60, Colors.white.withOpacity(0.06)),
        ),
        Positioned(
          bottom: 100,
          left: -20,
          child: _buildFloatingCircle(100, Colors.white.withOpacity(0.05)),
        ),

        // Subtle pattern overlay
        _buildPatternOverlay(),
      ],
    );
  }

  Widget _buildFloatingCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _buildPatternOverlay() {
    return Positioned.fill(
      child: CustomPaint(
        painter: _PatternPainter(),
      ),
    );
  }
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // Draw subtle grid pattern
    const spacing = 50.0;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}