import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/webbus_scaffold.dart';

class EmpresasScreen extends StatelessWidget {
  const EmpresasScreen({super.key});

  static const _empresas = <(String, String, String)>[
    ('Coolitoral', 'Transporte urbano en Barranquilla y municipios cercanos.', 'Ver rutas'),
    ('Transmecar', 'Rutas urbanas que conectan barrios principales.', 'Ver rutas'),
    ('Sobusa', 'Servicio de buses por zonas residenciales y comerciales.', 'Ver rutas'),
    ('La Carolina', 'Empresa tradicional de transporte urbano.', 'Ver rutas'),
    ('Transmetro', 'Sistema de transporte masivo tipo BRT.', 'Ver estaciones'),
    ('Boston Boston', 'Servicios de transporte urbano en la ciudad.', 'Ver rutas'),
    ('Puerto Colombia', 'Rutas hacia Puerto Colombia y zonas cercanas.', 'Ver rutas'),
  ];

  @override
  Widget build(BuildContext context) {
    return WebBusScaffold(
      mostrarAtras: true,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Elige la empresa de transporte',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorOscuro)),
          const Text(
            'Selecciona la empresa de buses para consultar sus rutas disponibles en Barranquilla',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          for (final e in _empresas)
            Card(
              child: ListTile(
                title: Text(e.$1, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(e.$2),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(110, 40)),
                  onPressed: () => mostrarMensaje(context, 'Rutas de ${e.$1}: próximamente'),
                  child: Text(e.$3),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
