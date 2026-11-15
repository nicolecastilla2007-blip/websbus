import 'package:flutter/material.dart';

import '../widgets/webbus_scaffold.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _clave = TextEditingController();
  final _confirmar = TextEditingController();

  @override
  void dispose() {
    _clave.dispose();
    _confirmar.dispose();
    super.dispose();
  }

  void _registrar() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: guardar el usuario en un backend real.
    mostrarMensaje(context, 'Registro exitoso');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WebBusScaffold(
      mostrarAtras: true,
      child: Form(
        key: _formKey,
        child: FormCard(
          titulo: 'Registrarse',
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nombre completo'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa tu nombre' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Correo electrónico'),
              validator: (v) => (v == null || !v.contains('@')) ? 'Ingresa un correo válido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _clave,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              validator: (v) => (v == null || v.isEmpty) ? 'Ingresa una contraseña' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _confirmar,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirmar contraseña'),
              validator: (v) => v != _clave.text ? 'Las contraseñas no coinciden' : null,
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _registrar, child: const Text('Registrarse')),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('¿Ya tienes una cuenta? Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
