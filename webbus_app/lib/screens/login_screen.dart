import 'package:flutter/material.dart';

import '../theme.dart';
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

  @override
  void dispose() {
    _correo.dispose();
    _clave.dispose();
    super.dispose();
  }

  void _entrar() {
    if (_formKey.currentState!.validate()) {
      // TODO: autenticar contra un backend real.
      Navigator.pushReplacementNamed(context, '/bienvenida');
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
          ElevatedButton(onPressed: _entrar, child: const Text('Iniciar sesión')),
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
          const Divider(height: 8),
          TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/admin'),
            icon: const Icon(Icons.admin_panel_settings_outlined, size: 18, color: colorAzul),
            label: const Text('Acceso administrador'),
          ),
        ],
      ),
    );
  }
}
