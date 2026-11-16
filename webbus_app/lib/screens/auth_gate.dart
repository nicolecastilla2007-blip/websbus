import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/modelos.dart';
import '../services/auth_service.dart';
import 'admin_screen.dart';
import 'conductor_screen.dart';
import 'home_shell.dart';
import 'login_screen.dart';

/// Decide qué pantalla mostrar según la sesión y el rol de la cuenta.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.sesion,
      builder: (context, sesion) {
        if (sesion.connectionState == ConnectionState.waiting) return const _Cargando();
        final usuario = sesion.data;
        if (usuario == null) return const LoginScreen();

        return StreamBuilder(
          stream: AuthService.perfil(usuario.uid),
          builder: (context, doc) {
            if (doc.hasError) {
              return _Error(mensaje: 'No se pudo cargar tu perfil.\n${doc.error}');
            }
            if (!doc.hasData || !doc.data!.exists) return const _Cargando();
            final perfil = Perfil.desde(doc.data!);
            switch (perfil.rol) {
              case 'admin':
                return AdminScreen(perfil: perfil);
              case 'conductor':
                return ConductorScreen(perfil: perfil);
              default:
                return HomeShell(perfil: perfil);
            }
          },
        );
      },
    );
  }
}

class _Cargando extends StatelessWidget {
  const _Cargando();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));
}

class _Error extends StatelessWidget {
  final String mensaje;

  const _Error({required this.mensaje});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(mensaje, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: AuthService.salir, child: const Text('Cerrar sesión')),
              ],
            ),
          ),
        ),
      );
}
