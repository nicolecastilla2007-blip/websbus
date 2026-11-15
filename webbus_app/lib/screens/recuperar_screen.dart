import 'package:flutter/material.dart';

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

  void _enviar() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: enviar el enlace real por correo desde un backend.
    _correo.clear();
    mostrarMensaje(context, 'Si el correo existe, recibirás un enlace para restablecer tu contraseña');
    Navigator.pushNamed(context, '/restablecer');
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
