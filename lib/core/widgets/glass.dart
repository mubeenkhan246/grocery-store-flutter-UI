import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

class LiquidBackground extends StatelessWidget {
  const LiquidBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children: [
        CustomPaint(
          painter: _LiquidFieldPainter(dark: dark),
          child: const SizedBox.expand(),
        ),
        child,
      ],
    );
  }
}

class _LiquidFieldPainter extends CustomPainter {
  const _LiquidFieldPainter({required this.dark});

  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    canvas.drawRect(
      rect,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: dark
              ? const [Color(0xFF06120B), Color(0xFF132119), Color(0xFF080A0E)]
              : const [Color(0xFFFAFFFA), Color(0xFFEAF8EF), Color(0xFFFFFBF0)],
        ).createShader(rect),
    );

    canvas.drawRect(
      rect,
      Paint()
        ..shader = SweepGradient(
          startAngle: 0,
          endAngle: math.pi * 2,
          colors: dark
              ? const [Color(0x2216A34A), Color(0x181E293B), Color(0x2238BDF8), Color(0x2216A34A)]
              : const [Color(0x44B7F7C4), Color(0x33FFF0B3), Color(0x33C7E8FF), Color(0x44B7F7C4)],
        ).createShader(rect.inflate(size.shortestSide * .2)),
    );

    final reflection = Paint()
      ..color = Colors.white.withValues(alpha: dark ? .045 : .28)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    for (var i = 0; i < 8; i++) {
      final y = size.height * (.08 + i * .13);
      final path = Path()
        ..moveTo(-40, y)
        ..cubicTo(size.width * .25, y - 42, size.width * .55, y + 42, size.width + 40, y - 18);
      canvas.drawPath(path, reflection);
    }
  }

  @override
  bool shouldRepaint(covariant _LiquidFieldPainter oldDelegate) => oldDelegate.dark != dark;
}

class GlassPanel extends StatelessWidget {
  const GlassPanel({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.radius = 32,
    this.onTap,
    this.opacity,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final double? opacity;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final panel = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: (dark ? Colors.white : Colors.white).withValues(alpha: opacity ?? (dark ? .09 : .48)),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: Colors.white.withValues(alpha: dark ? .12 : .68), width: 1.1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: dark ? .32 : .08),
                blurRadius: 28,
                offset: const Offset(0, 18),
              ),
              BoxShadow(color: Colors.white.withValues(alpha: dark ? .04 : .55), blurRadius: 6, offset: const Offset(-2, -2)),
            ],
          ),
          child: child,
        ),
      ),
    );
    if (onTap == null) return panel;
    return GestureDetector(onTap: onTap, child: panel);
  }
}

class GlassIconButton extends StatelessWidget {
  const GlassIconButton({required this.icon, this.onTap, this.size = 48, this.label, super.key});

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label ?? '',
      child: GlassPanel(
        radius: size / 2,
        padding: EdgeInsets.zero,
        onTap: onTap,
        child: SizedBox(width: size, height: size, child: Icon(icon, size: size * .45)),
      ),
    );
  }
}

class PrimaryGlassButton extends StatelessWidget {
  const PrimaryGlassButton({required this.label, required this.icon, this.onTap, this.expanded = true, super.key});

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: FilledButton.styleFrom(
        minimumSize: const Size(0, 58),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: const Color(0xFF16A34A),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
      ),
    );
    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {this.action, this.onAction, super.key});

  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        if (action != null) TextButton(onPressed: onAction, child: Text(action!)),
      ],
    );
  }
}
