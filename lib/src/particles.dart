import 'dart:math' as math;
import 'package:flutter/material.dart';

class ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double time;

  ParticlePainter({required this.particles, required this.time});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final x = p.centerX * size.width +
          math.cos(p.angle + time * p.speed) * p.radius * size.width;
      final y = p.centerY * size.height +
          math.sin(p.angle + time * p.speed * 0.7) * p.radius * size.height;

      final paint = Paint()
        ..color = Colors.white.withOpacity(p.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(ParticlePainter old) => old.time != time;
}

class _Particle {
  final double centerX;
  final double centerY;
  final double radius;
  final double speed;
  final double angle;
  final double size;
  final double opacity;

  const _Particle({
    required this.centerX,
    required this.centerY,
    required this.radius,
    required this.speed,
    required this.angle,
    required this.size,
    required this.opacity,
  });
}

List<_Particle> generateParticles(int count) {
  final random = math.Random(42);
  return List.generate(count, (_) {
    return _Particle(
      centerX: random.nextDouble(),
      centerY: random.nextDouble(),
      radius: 0.03 + random.nextDouble() * 0.1,
      speed: 0.3 + random.nextDouble() * 0.7,
      angle: random.nextDouble() * 2 * math.pi,
      size: 4 + random.nextDouble() * 14,
      opacity: 0.05 + random.nextDouble() * 0.15,
    );
  });
}
