import 'package:flutter/material.dart';

import '../widgets/webbus_scaffold.dart';

class RecuperarScreen extends StatefulWidget {
  const RecuperarScreen({super.key});

  @override
  State<RecuperarScreen> createState() => _RecuperarScreenState();
}

class _RecuperarScreenState extends State<RecuperarScreen> {
  final _correo = TextEditingController();

  @override
  void dispose() {
    _correo.dispose();
    super.dispose();
  }

  void _enviar() {
    if (!_correo.text.contains('@')) {
      mostrarMensaje(context, 'Ingresa un correo válido');
      return;
    }
    // TODO: enviar el enlace real por correo desde un backend.
    _correo.clear();
    mostrarMensaje(context, 'Si el correo existe, recibirás un enlace para restablecer tu contraseña');
    Navigator.pushNamed(context, '/restablecer');
  }

  @override
  Widget build(BuildContext context) {
    return WebBusScaffold(
      mostrarAtras: true,
      child: FormCard(
        titulo: 'Recuperar contraseña',
        children: [
          const Text(
            'Ingresa tu correo electrónico y te enviaremos un enlace para restablecer tu contraseña.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _correo,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Correo electrónico'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _enviar, child: const Text('Enviar enlace')),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('¿Recordaste tu contraseña? Iniciar sesión'),
          ),
        ],
      ),
    );
  }
}
