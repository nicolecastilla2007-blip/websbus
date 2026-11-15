import 'package:flutter/material.dart';

import 'screens/admin_login_screen.dart';
import 'screens/home_shell.dart';
import 'screens/login_screen.dart';
import 'screens/recuperar_screen.dart';
import 'screens/registro_screen.dart';
import 'screens/restablecer_screen.dart';
import 'theme.dart';

void main() => runApp(const WebBusApp());

class WebBusApp extends StatelessWidget {
  const WebBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebBus',
      debugShowCheckedModeBanner: false,
      theme: webBusTheme(),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/admin': (_) => const AdminLoginScreen(),
        '/registro': (_) => const RegistroScreen(),
        '/recuperar': (_) => const RecuperarScreen(),
        '/restablecer': (_) => const RestablecerScreen(),
        '/bienvenida': (_) => const HomeShell(),
      },
    );
  }
}
