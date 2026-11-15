import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/webbus_scaffold.dart';

class BienvenidaScreen extends StatelessWidget {
  const BienvenidaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final opciones = <(String, String, String?)>[
      ('Ver rutas', 'Consultar las rutas de los buses.', '/empresas'),
      ('Paradas cercanas', 'Buscar paradas de buses cercanas.', '/paradas'),
      ('Planificar viaje', 'Planificar una ruta desde un origen a un destino.', null),
      ('Estado del servicio', 'Ver el estado actual del servicio.', null),
      ('Historial de viajes', 'Ver el historial de tus viajes anteriores.', null),
      ('Mis rutas favoritas', 'Acceder a tus rutas favoritas guardadas.', null),
    ];

    return WebBusScaffold(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Bienvenido',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colorOscuro)),
          const Text('¿Qué deseas hacer hoy?', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              for (final o in opciones)
                SizedBox(
                  width: 260,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(o.$1, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text(o.$2),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: () => o.$3 != null
                                ? Navigator.pushNamed(context, o.$3!)
                                : mostrarMensaje(context, 'Próximamente'),
                            child: const Text('Ver'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );
  }
}
