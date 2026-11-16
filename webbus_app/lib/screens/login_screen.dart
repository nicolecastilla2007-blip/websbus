import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _correo = TextEditingController();
  final _clave = TextEditingController();
  bool _cargando = false;

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _cargando = true);
    try {
      await AuthService.iniciarSesion(_correo.text.trim(), _clave.text);
    } on FirebaseAuthException catch (e) {
      if (mounted) mostrarMensaje(context, mensajeAuth(e));
    } finally {
      if (mounted) setState(() => _cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: AuthScaffold(
        titulo: 'Bienvenido de nuevo',
        subtitulo: 'Inicia sesión para continuar',
        children: [
          CampoTexto(
            etiqueta: 'Correo electrónico',
            icono: Icons.mail_outline_rounded,
            controller: _correo,
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
            onSubmitted: (_) => _entrar(),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.pushNamed(context, '/recuperar'),
              child: const Text('¿Olvidaste tu contraseña?'),
            ),
          ),
          const SizedBox(height: 4),
          ElevatedButton(
            onPressed: _cargando ? null : _entrar,
            child: _cargando
                ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5))
                : const Text('Iniciar sesión'),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿No tienes cuenta?'),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/registro'),
                child: const Text('Regístrate', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
