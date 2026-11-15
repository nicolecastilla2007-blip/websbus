import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../theme.dart';
import '../widgets/ui.dart';

class ParadasTab extends StatefulWidget {
  const ParadasTab({super.key});

  @override
  State<ParadasTab> createState() => _ParadasTabState();
}

class _ParadasTabState extends State<ParadasTab> {
  static const _centroInicial = LatLng(10.9685, -74.7813);

  static const _paradas = <(String, LatLng)>[
    ('Avenida Murillo y Carrera 33', LatLng(10.9685, -74.7813)),
    ('Carrera 33 y Calle 45', LatLng(10.9698, -74.7800)),
    ('Avenida Murillo y Carrera 34', LatLng(10.9672, -74.7831)),
    ('Carrera 33 y Calle 47', LatLng(10.9660, -74.7840)),
    ('Carrera 34 y Calle 43B', LatLng(10.9705, -74.7820)),
    ('Carrera 33 y Calle 43', LatLng(10.9690, -74.7825)),
  ];

  final _mapa = MapController();
  final _direccion = TextEditingController();
  LatLng? _usuario;
  LatLng? _busqueda;
  String _busquedaTexto = '';
  bool _buscando = false;

  @override
  void initState() {
    super.initState();
    _ubicarUsuario();
  }

  @override
  void dispose() {
    _direccion.dispose();
    super.dispose();
  }

  Future<void> _ubicarUsuario() async {
    try {
      var permiso = await Geolocator.checkPermission();
      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }
      if (permiso == LocationPermission.denied || permiso == LocationPermission.deniedForever) {
        throw Exception('permiso denegado');
      }
      final pos = await Geolocator.getCurrentPosition();
      if (!mounted) return;
      final punto = LatLng(pos.latitude, pos.longitude);
      setState(() => _usuario = punto);
      _mapa.move(punto, 17);
    } catch (_) {
      if (mounted) mostrarMensaje(context, 'Activa la ubicación para ver tu posición en el mapa.');
    }
  }

  Future<List<dynamic>> _consultar(String direccion, String ciudad) async {
    final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
      'format': 'json',
      'q': '$direccion, $ciudad, Atlantico, Colombia',
      'limit': '1',
    });
    // Los navegadores no permiten fijar User-Agent; en móvil sí.
    final res = await http.get(uri, headers: kIsWeb ? {} : {'User-Agent': 'WebBusApp/1.0'});
    return jsonDecode(res.body) as List<dynamic>;
  }

  Future<void> _buscar() async {
    FocusScope.of(context).unfocus();
    final texto = _direccion.text.trim().replaceAll(RegExp(r'\s*&\s*'), ' y ');
    if (texto.isEmpty) {
      mostrarMensaje(context, 'Escribe una dirección');
      return;
    }
    final consulta = texto.replaceAll(' y ', ' & ');
    setState(() => _buscando = true);
    try {
      var datos = await _consultar(consulta, 'Barranquilla');
      if (datos.isEmpty) datos = await _consultar(consulta, 'Soledad');
      if (!mounted) return;
      if (datos.isEmpty) {
        mostrarMensaje(context, 'Dirección no encontrada en Barranquilla o Soledad');
        return;
      }
      final punto = LatLng(double.parse(datos[0]['lat']), double.parse(datos[0]['lon']));
      setState(() {
        _busqueda = punto;
        _busquedaTexto = texto;
      });
      _mapa.move(punto, 17);
    } catch (_) {
      if (mounted) mostrarMensaje(context, 'No se pudo realizar la búsqueda. Revisa tu conexión.');
    } finally {
      if (mounted) setState(() => _buscando = false);
    }
  }

  Marker _pin(LatLng p, Color color, IconData icono, String texto, {double tam = 42}) {
    return Marker(
      point: p,
      width: tam,
      height: tam,
      child: GestureDetector(
        onTap: () => mostrarMensaje(context, texto),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: Icon(icono, color: Colors.white, size: tam * 0.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arriba = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapa,
          options: const MapOptions(initialCenter: _centroInicial, initialZoom: 15),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.webbus.app',
            ),
            if (_usuario != null)
              CircleLayer(circles: [
                CircleMarker(
                  point: _usuario!,
                  radius: 45,
                  useRadiusInMeter: true,
                  color: colorPrimario.withValues(alpha: 0.25),
                  borderColor: colorPrimario,
                  borderStrokeWidth: 1,
                ),
              ]),
            MarkerLayer(markers: [
              for (final p in _paradas) _pin(p.$2, colorAzul, Icons.directions_bus_rounded, 'Parada: ${p.$1}'),
              if (_busqueda != null)
                _pin(_busqueda!, Colors.deepOrange, Icons.place_rounded, _busquedaTexto, tam: 48),
              if (_usuario != null) _pin(_usuario!, colorPrimario, Icons.person_rounded, 'Estás aquí', tam: 34),
            ]),
            const RichAttributionWidget(
              alignment: AttributionAlignment.bottomLeft,
              attributions: [TextSourceAttribution('© OpenStreetMap contributors')],
            ),
          ],
        ),
        Positioned(
          top: arriba + 12,
          left: 16,
          right: 16,
          child: Material(
            elevation: 6,
            shadowColor: Colors.black38,
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 4),
                    child: Icon(Icons.search_rounded, color: colorAzul),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _direccion,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _buscar(),
                      decoration: const InputDecoration(
                        hintText: 'Busca una dirección...',
                        filled: false,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  _buscando
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                        )
                      : IconButton(
                          onPressed: _buscar,
                          icon: const Icon(Icons.arrow_forward_rounded, color: colorAzul),
                        ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: MediaQuery.of(context).size.height * 0.27,
          child: FloatingActionButton.small(
            heroTag: 'mi_ubicacion',
            backgroundColor: Colors.white,
            foregroundColor: colorAzul,
            onPressed: _ubicarUsuario,
            child: const Icon(Icons.my_location_rounded),
          ),
        ),
        DraggableScrollableSheet(
          initialChildSize: 0.24,
          minChildSize: 0.1,
          maxChildSize: 0.6,
          builder: (context, controlador) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.18), blurRadius: 20, offset: const Offset(0, -4)),
                ],
              ),
              child: ListView(
                controller: controlador,
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 4, 20, 8),
                    child: Text('Paradas cercanas',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colorOscuro)),
                  ),
                  for (final p in _paradas)
                    ListTile(
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: colorAzul.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.directions_bus_rounded, color: colorAzul, size: 22),
                      ),
                      title: Text(p.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
                      trailing: const Icon(Icons.near_me_rounded, color: colorPrimario, size: 20),
                      onTap: () => _mapa.move(p.$2, 18),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
