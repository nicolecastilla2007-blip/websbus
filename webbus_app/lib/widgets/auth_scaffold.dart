import 'package:flutter/material.dart';

import '../theme.dart';

/// Fondo con degradado, logo arriba y una tarjeta blanca con el formulario.
class AuthScaffold extends StatelessWidget {
  final String titulo;
  final String? subtitulo;
  final List<Widget> children;
  final bool mostrarAtras;

  const AuthScaffold({
    super.key,
    required this.titulo,
    this.subtitulo,
    required this.children,
    this.mostrarAtras = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: degradadoMarca),
        child: Stack(
          children: [
            Positioned(top: -70, right: -60, child: _circulo(220, 0.07)),
            Positioned(top: 140, left: -90, child: _circulo(180, 0.05)),
            Positioned(bottom: -80, right: -40, child: _circulo(240, 0.06)),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (mostrarAtras)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                              onPressed: () => Navigator.maybePop(context),
                            ),
                          )
                        else
                          const SizedBox(height: 16),
                        Center(
                          child: Container(
                            width: 92,
                            height: 92,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.25),
                                  blurRadius: 24,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Image.asset('assets/imagenes/iconoWebBus.png', fit: BoxFit.contain),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'WebBus',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Text(
                          'Sigue tu bus en tiempo real',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 30,
                                offset: const Offset(0, 14),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                titulo,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                  color: colorOscuro,
                                ),
                              ),
                              if (subtitulo != null) ...[
                                const SizedBox(height: 6),
                                Text(subtitulo!, style: const TextStyle(color: Colors.black54)),
                              ],
                              const SizedBox(height: 22),
                              ...children,
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          '© 2026 Web Bus · Nicole Castilla, Marlon Pertuz y Joshua Castro',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white60, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _circulo(double tam, double opacidad) => Container(
        width: tam,
        height: tam,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: opacidad),
        ),
      );
}
