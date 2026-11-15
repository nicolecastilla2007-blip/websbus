import 'package:flutter/material.dart';

import '../widgets/auth_scaffold.dart';
import '../widgets/ui.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AuthScaffold(
        mostrarAtras: true,
        titulo: 'Administrador',
        subtitulo: 'Acceso exclusivo para el personal',
        children: [
          const CampoTexto(
            etiqueta: 'Correo electrónico',
            icono: Icons.mail_outline_rounded,
            teclado: TextInputType.emailAddress,
            validator: validarCorreo,
          ),
          const SizedBox(height: 14),
          const CampoTexto(
            etiqueta: 'Contraseña',
            icono: Icons.lock_outline_rounded,
            esClave: true,
            validator: validarObligatorio,
          ),
          const SizedBox(height: 22),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                mostrarMensaje(context, 'Panel de administrador en construcción');
              }
            },
            child: const Text('Iniciar sesión'),
          ),
        ],
      ),
    );
  }
}
