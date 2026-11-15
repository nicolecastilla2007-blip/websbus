import 'package:flutter/material.dart';

import '../widgets/auth_scaffold.dart';
import '../widgets/ui.dart';

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
    mostrarMensaje(context, 'Contraseña actualizada. Ya puedes iniciar sesión.');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AuthScaffold(
        mostrarAtras: true,
        titulo: 'Nueva contraseña',
        subtitulo: 'Elige una contraseña y confírmala',
        children: [
          CampoTexto(
            etiqueta: 'Nueva contraseña',
            icono: Icons.lock_outline_rounded,
            controller: _clave,
            esClave: true,
            validator: validarObligatorio,
          ),
          const SizedBox(height: 14),
          CampoTexto(
            etiqueta: 'Confirmar contraseña',
            icono: Icons.lock_reset_rounded,
            controller: _confirmar,
            esClave: true,
            validator: (v) => v != _clave.text ? 'Las contraseñas no coinciden' : null,
          ),
          const SizedBox(height: 22),
          ElevatedButton(onPressed: _guardar, child: const Text('Restablecer contraseña')),
        ],
      ),
    );
  }
}
