import 'package:flutter/material.dart';

import '../theme.dart';

/// Estructura común: barra superior con logo, contenido centrado y pie.
class WebBusScaffold extends StatelessWidget {
  final Widget child;
  final bool mostrarAtras;

  const WebBusScaffold({super.key, required this.child, this.mostrarAtras = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorOscuro,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: mostrarAtras,
        title: Row(
          children: [
            Image.asset('assets/imagenes/iconoWebBus.png', height: 32),
            const SizedBox(width: 8),
            const Text('WebBus', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: child,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8),
              child: Text(
                '© 2026 Web Bus - Nicole Castilla, Marlon Pertuz y Joshua Castro.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tarjeta blanca centrada para los formularios.
class FormCard extends StatelessWidget {
  final String titulo;
  final List<Widget> children;

  const FormCard({super.key, required this.titulo, required this.children});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    titulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorOscuro),
                  ),
                  const SizedBox(height: 20),
                  ...children,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void mostrarMensaje(BuildContext context, String texto) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
}
