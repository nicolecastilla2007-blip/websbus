import 'package:flutter/material.dart';

/// Logo de WebBus dibujado en código: pin verde con un bus azul.
/// Se ve nítido en cualquier tamaño y sin fondo.
class LogoWebBus extends StatelessWidget {
  final double tam;
  final bool sombra;

  const LogoWebBus({super.key, this.tam = 80, this.sombra = true});

  @override
  Widget build(BuildContext context) {
    final alto = tam * 1.15;
    return SizedBox(
      width: tam,
      height: alto,
      child: Stack(
        children: [
          CustomPaint(size: Size(tam, alto), painter: _PinPainter(sombra)),
          Positioned(
            left: 0,
            right: 0,
            top: alto * 0.38 - tam * 0.17,
            child: Icon(Icons.directions_bus_rounded, size: tam * 0.34, color: const Color(0xFF1E6FC9)),
          ),
        ],
      ),
    );
  }
}

class _PinPainter extends CustomPainter {
  final bool sombra;

  _PinPainter(this.sombra);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final pin = Path()
      ..moveTo(w * 0.5, h * 0.98)
      ..cubicTo(w * 0.18, h * 0.62, w * 0.06, h * 0.50, w * 0.06, h * 0.38)
      ..arcToPoint(Offset(w * 0.94, h * 0.38), radius: Radius.circular(w * 0.44), clockwise: true)
      ..cubicTo(w * 0.94, h * 0.50, w * 0.82, h * 0.62, w * 0.5, h * 0.98)
      ..close();

    if (sombra) {
      canvas.drawShadow(pin, Colors.black, 8, true);
    }

    canvas.drawPath(
      pin,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF7ED957), Color(0xFF2E9E3A)],
        ).createShader(Rect.fromLTWH(0, 0, w, h)),
    );
    canvas.drawPath(
      pin,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.045
        ..color = Colors.white,
    );
    canvas.drawCircle(Offset(w * 0.5, h * 0.38), w * 0.27, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _PinPainter old) => old.sombra != sombra;
}
