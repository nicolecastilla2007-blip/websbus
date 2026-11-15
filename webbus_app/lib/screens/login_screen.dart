import 'package:flutter/material.dart';

import '../widgets/webbus_scaffold.dart';

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
    return WebBusScaffold(
      child: Form(
        key: _formKey,
        child: FormCard(
          titulo: 'Iniciar sesión',
          children: [
            Image.asset('assets/imagenes/bus.png', height: 90),
            const SizedBox(height: 12),
            TextFormField(
              controller: _correo,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Correo electrónico', hintText: 'Ingresa tu email'),
              validator: (v) => (v == null || !v.contains('@')) ? 'Ingresa un correo válido' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _clave,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña', hintText: 'Ingresa tu contraseña'),
              validator: (v) => (v == null || v.isEmpty) ? 'Ingresa tu contraseña' : null,
              onFieldSubmitted: (_) => _entrar(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.pushNamed(context, '/recuperar'),
                child: const Text('¿Olvidaste tu contraseña?'),
              ),
            ),
            ElevatedButton(onPressed: _entrar, child: const Text('Iniciar sesión')),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/registro'),
              child: const Text('¿No tienes una cuenta? Registrarse'),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/admin'),
              child: const Text('¿Eres administrador? Iniciar sesión como administrador'),
            ),
          ],
        ),
      ),
    );
  }
}
