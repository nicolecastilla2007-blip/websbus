import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/ui.dart';

class EmpresasTab extends StatelessWidget {
  const EmpresasTab({super.key});

  static const _empresas = <_Empresa>[
    _Empresa('Coolitoral', 'Transporte urbano en Barranquilla y municipios cercanos.', 'Ver rutas', Color(0xFF1FA2FF)),
    _Empresa('Transmecar', 'Rutas urbanas que conectan barrios principales.', 'Ver rutas', Color(0xFF28A745)),
    _Empresa('Sobusa', 'Servicio de buses por zonas residenciales y comerciales.', 'Ver rutas', Color(0xFFFF9800)),
    _Empresa('La Carolina', 'Empresa tradicional de transporte urbano.', 'Ver rutas', Color(0xFFE91E63)),
    _Empresa('Transmetro', 'Sistema de transporte masivo tipo BRT.', 'Ver estaciones', Color(0xFF7C4DFF)),
    _Empresa('Boston Boston', 'Servicios de transporte urbano en la ciudad.', 'Ver rutas', Color(0xFF00ACC1)),
    _Empresa('Puerto Colombia', 'Rutas hacia Puerto Colombia y zonas cercanas.', 'Ver rutas', Color(0xFF795548)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(22, MediaQuery.of(context).padding.top + 18, 22, 24),
          decoration: const BoxDecoration(
            gradient: degradadoMarca,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Empresas de transporte',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
              SizedBox(height: 6),
              Text('Elige una empresa para consultar sus rutas en Barranquilla',
                  style: TextStyle(color: Colors.white70)),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: _empresas.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final e = _empresas[i];
              return Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => mostrarMensaje(context, 'Rutas de ${e.nombre}: próximamente'),
                  child: Ink(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: colorOscuro.withValues(alpha: 0.07),
                          blurRadius: 16,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: e.color.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            e.nombre[0],
                            style: TextStyle(color: e.color, fontSize: 24, fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.nombre,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w800, color: colorOscuro)),
                              const SizedBox(height: 2),
                              Text(e.descripcion,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(color: Colors.black54, fontSize: 12.5)),
                              const SizedBox(height: 6),
                              Text(e.accion,
                                  style: TextStyle(
                                      color: e.color, fontWeight: FontWeight.w700, fontSize: 12.5)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: Colors.black38),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Empresa {
  final String nombre;
  final String descripcion;
  final String accion;
  final Color color;

  const _Empresa(this.nombre, this.descripcion, this.accion, this.color);
}
