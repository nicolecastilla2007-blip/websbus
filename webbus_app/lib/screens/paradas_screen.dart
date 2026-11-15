import 'dart:convert';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

import '../theme.dart';
import '../widgets/webbus_scaffold.dart';

class ParadasScreen extends StatefulWidget {
  const ParadasScreen({super.key});

  @override
  State<ParadasScreen> createState() => _ParadasScreenState();
}

class _ParadasScreenState extends State<ParadasScreen> {
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

  Marker _marcador(LatLng p, Color color, IconData icono, String texto) {
    return Marker(
      point: p,
      width: 44,
      height: 44,
      child: GestureDetector(
        onTap: () => mostrarMensaje(context, texto),
        child: Icon(icono, color: color, size: 40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WebBusScaffold(
      mostrarAtras: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _direccion,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _buscar(),
                    decoration: const InputDecoration(hintText: 'Ingresa tu dirección...'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(90, 48)),
                  onPressed: _buscando ? null : _buscar,
                  child: _buscando
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Buscar'),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: FlutterMap(
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
                      radius: 40,
                      useRadiusInMeter: true,
                      color: colorPrimario.withValues(alpha: 0.3),
                      borderColor: colorPrimario,
                      borderStrokeWidth: 1,
                    ),
                  ]),
                MarkerLayer(markers: [
                  for (final p in _paradas)
                    _marcador(p.$2, colorAzul, Icons.directions_bus, 'Parada: ${p.$1}'),
                  if (_usuario != null) _marcador(_usuario!, Colors.red, Icons.person_pin_circle, 'Estás aquí'),
                  if (_busqueda != null) _marcador(_busqueda!, Colors.deepOrange, Icons.place, _busquedaTexto),
                ]),
                const RichAttributionWidget(
                  attributions: [TextSourceAttribution('© OpenStreetMap contributors')],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: ListView(
              children: [
                for (final p in _paradas)
                  ListTile(
                    leading: const Icon(Icons.directions_bus, color: colorAzul),
                    title: Text(p.$1),
                    trailing: TextButton(
                      onPressed: () => _mapa.move(p.$2, 18),
                      child: const Text('Ver'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
