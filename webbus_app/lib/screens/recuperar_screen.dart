import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/ui.dart';

class RecuperarScreen extends StatefulWidget {
  const RecuperarScreen({super.key});

  @override
  State<RecuperarScreen> createState() => _RecuperarScreenState();
}

class _RecuperarScreenState extends State<RecuperarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correo = TextEditingController();

  @override
  void dispose() {
    _correo.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      await AuthService.recuperar(_correo.text.trim());
      if (!mounted) return;
      mostrarMensaje(context, 'Te enviamos un enlace a tu correo para restablecer la contraseña');
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (mounted) mostrarMensaje(context, mensajeAuth(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AuthScaffold(
        mostrarAtras: true,
        titulo: 'Recuperar contraseña',
        subtitulo: 'Te enviaremos un enlace para restablecerla',
        children: [
          CampoTexto(
            etiqueta: 'Correo electrónico',
            icono: Icons.mail_outline_rounded,
            controller: _correo,
            teclado: TextInputType.emailAddress,
            validator: validarCorreo,
            onSubmitted: (_) => _enviar(),
          ),
          const SizedBox(height: 22),
          ElevatedButton(onPressed: _enviar, child: const Text('Enviar enlace')),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Volver a iniciar sesión'),
          ),
        ],
      ),
    );
  }
}
