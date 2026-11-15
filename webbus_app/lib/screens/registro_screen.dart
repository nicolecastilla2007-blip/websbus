import 'package:flutter/material.dart';

import '../widgets/auth_scaffold.dart';
import '../widgets/ui.dart';

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
    return Form(
      key: _formKey,
      child: AuthScaffold(
        mostrarAtras: true,
        titulo: 'Crea tu cuenta',
        subtitulo: 'Solo te tomará un minuto',
        children: [
          const CampoTexto(
            etiqueta: 'Nombre completo',
            icono: Icons.person_outline_rounded,
            validator: validarObligatorio,
          ),
          const SizedBox(height: 14),
          const CampoTexto(
            etiqueta: 'Correo electrónico',
            icono: Icons.mail_outline_rounded,
            teclado: TextInputType.emailAddress,
            validator: validarCorreo,
          ),
          const SizedBox(height: 14),
          CampoTexto(
            etiqueta: 'Contraseña',
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
          ElevatedButton(onPressed: _registrar, child: const Text('Registrarme')),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes cuenta?'),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Inicia sesión', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
