import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/auth_gate.dart';
import 'screens/recuperar_screen.dart';
import 'screens/registro_screen.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const WebBusApp());
}

class WebBusApp extends StatelessWidget {
  const WebBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WebBus',
      debugShowCheckedModeBanner: false,
      theme: webBusTheme(),
      home: const AuthGate(),
      routes: {
        '/registro': (_) => const RegistroScreen(),
        '/recuperar': (_) => const RecuperarScreen(),
      },
    );
  }
}
