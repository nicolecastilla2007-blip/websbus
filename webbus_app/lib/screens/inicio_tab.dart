import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/ui.dart';

class InicioTab extends StatelessWidget {
  final void Function(int) onIrA;

  const InicioTab({super.key, required this.onIrA});

  @override
  Widget build(BuildContext context) {
    final accesos = <_Acceso>[
      _Acceso('Ver rutas', 'Empresas y recorridos', Icons.alt_route_rounded, const Color(0xFF1FA2FF), 1),
      _Acceso('Paradas cercanas', 'Encuentra la más cerca', Icons.place_rounded, const Color(0xFF28A745), 2),
      _Acceso('Planificar viaje', 'Origen y destino', Icons.map_rounded, const Color(0xFF7C4DFF), null),
      _Acceso('Estado del servicio', 'Novedades en vivo', Icons.speed_rounded, const Color(0xFFFF9800), null),
      _Acceso('Historial', 'Tus viajes anteriores', Icons.history_rounded, const Color(0xFF00ACC1), null),
      _Acceso('Favoritas', 'Rutas guardadas', Icons.favorite_rounded, const Color(0xFFE91E63), null),
    ];

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(22, MediaQuery.of(context).padding.top + 18, 22, 30),
          decoration: const BoxDecoration(
            gradient: degradadoMarca,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Image.asset('assets/imagenes/iconoWebBus.png', fit: BoxFit.contain),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'WebBus',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: 'Cerrar sesión',
                    onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                    icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 26),
              const Text(
                'Hola 👋',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 2),
              const Text(
                '¿A dónde vamos hoy?',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 18),
              Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => onIrA(2),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Icon(Icons.search_rounded, color: colorAzul),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text('Buscar una parada o dirección',
                              style: TextStyle(color: Colors.black54, fontSize: 15)),
                        ),
                        Icon(Icons.arrow_forward_rounded, color: colorAzul, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: _sombra,
            ),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(color: colorVerde, shape: BoxShape.circle),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Servicio operando con normalidad',
                      style: TextStyle(fontWeight: FontWeight.w600, color: colorOscuro)),
                ),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(22, 24, 22, 10),
          child: Text('Accesos rápidos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colorOscuro)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.05,
            children: [
              for (final a in accesos)
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  elevation: 0,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => a.tab != null ? onIrA(a.tab!) : mostrarMensaje(context, 'Próximamente'),
                    child: Ink(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: _sombra,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: a.color.withValues(alpha: 0.14),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(a.icono, color: a.color),
                          ),
                          const Spacer(),
                          Text(a.titulo,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, fontSize: 15, color: colorOscuro)),
                          const SizedBox(height: 2),
                          Text(a.detalle,
                              style: const TextStyle(color: Colors.black54, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _Acceso {
  final String titulo;
  final String detalle;
  final IconData icono;
  final Color color;
  final int? tab;

  const _Acceso(this.titulo, this.detalle, this.icono, this.color, this.tab);
}

final _sombra = [
  BoxShadow(
    color: colorOscuro.withValues(alpha: 0.08),
    blurRadius: 18,
    offset: const Offset(0, 6),
  ),
];
