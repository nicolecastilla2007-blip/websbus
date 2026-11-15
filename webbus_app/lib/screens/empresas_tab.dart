import 'package:flutter/material.dart';

import '../theme.dart';
import '../widgets/logo_webbus.dart';
import '../widgets/ui.dart';

class EmpresasTab extends StatefulWidget {
  const EmpresasTab({super.key});

  @override
  State<EmpresasTab> createState() => _EmpresasTabState();
}

class _EmpresasTabState extends State<EmpresasTab> {
  String _filtro = '';

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
    final lista = _empresas
        .where((e) => e.nombre.toLowerCase().contains(_filtro.toLowerCase().trim()))
        .toList();

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(22, MediaQuery.of(context).padding.top + 18, 22, 22),
          decoration: const BoxDecoration(
            gradient: degradadoMarca,
            image: DecorationImage(
              image: AssetImage('assets/imagenes/fondo.png'),
              fit: BoxFit.cover,
              opacity: 0.22,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  LogoWebBus(tam: 30, sombra: false),
                  SizedBox(width: 10),
                  Text('WebBus',
                      style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 14),
              const Text('Empresas de transporte',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text('Elige una empresa para consultar sus rutas en Barranquilla',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 16),
              TextField(
                onChanged: (v) => setState(() => _filtro = v),
                decoration: const InputDecoration(
                  hintText: 'Buscar empresa',
                  prefixIcon: Icon(Icons.search_rounded, color: colorAzul),
                  fillColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: lista.isEmpty
              ? const Center(child: Text('No hay empresas con ese nombre'))
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: lista.length,
                  separatorBuilder: (context, indice) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => Aparecer(indice: i, child: _tarjeta(context, lista[i])),
                ),
        ),
      ],
    );
  }

  Widget _tarjeta(BuildContext context, _Empresa e) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => mostrarMensaje(context, 'Rutas de ${e.nombre}: próximamente'),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
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
                width: 56,
                height: 56,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [e.color.withValues(alpha: 0.7), e.color],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(color: e.color.withValues(alpha: 0.35), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Text(
                  e.nombre[0],
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.nombre,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: colorOscuro)),
                    const SizedBox(height: 2),
                    Text(e.descripcion,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54, fontSize: 12.5)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color: e.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(e.accion,
                          style: TextStyle(color: e.color, fontWeight: FontWeight.w700, fontSize: 12)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.black38),
            ],
          ),
        ),
      ),
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
