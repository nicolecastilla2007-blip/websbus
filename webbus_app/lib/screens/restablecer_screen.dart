import 'package:flutter/material.dart';

import '../widgets/webbus_scaffold.dart';

class RestablecerScreen extends StatefulWidget {
  const RestablecerScreen({super.key});

  @override
  State<RestablecerScreen> createState() => _RestablecerScreenState();
}

class _RestablecerScreenState extends State<RestablecerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clave = TextEditingController();
  final _confirmar = TextEditingController();

  @override
  void dispose() {
    _clave.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;
    mostrarMensaje(context, 'Contraseña actualizada correctamente. Ahora puedes iniciar sesión.');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return WebBusScaffold(
      mostrarAtras: true,
      child: Form(
        key: _formKey,
        child: FormCard(
          titulo: 'Restablecer contraseña',
          children: [
            const Text(
              'Ingresa tu nueva contraseña y confírmala.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _clave,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nueva contraseña'),
              validator: (v) => (v == null || v.isEmpty) ? 'Ingresa una contraseña' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmar,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirmar nueva contraseña'),
              validator: (v) => v != _clave.text ? 'Las contraseñas no coinciden' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _guardar, child: const Text('Restablecer contraseña')),
          ],
        ),
      ),
    );
  }
}
