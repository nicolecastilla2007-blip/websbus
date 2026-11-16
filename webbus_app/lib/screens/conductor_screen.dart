import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/modelos.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/logo_webbus.dart';
import '../widgets/ui.dart';

class ConductorScreen extends StatefulWidget {
  final Perfil perfil;

  const ConductorScreen({super.key, required this.perfil});

  @override
  State<ConductorScreen> createState() => _ConductorScreenState();
}

class _ConductorScreenState extends State<ConductorScreen> {
  Ruta? _ruta;
  StreamSubscription<Position>? _sub;
  Position? _ultima;
  int _envios = 0;

  DocumentReference<Map<String, dynamic>> get _doc =>
      FirebaseFirestore.instance.collection('buses_activos').doc(widget.perfil.uid);

  bool get _activo => _sub != null;

  @override
  void dispose() {
    _sub?.cancel();
    if (_sub != null) _doc.delete();
    super.dispose();
  }

  Future<void> _iniciar() async {
    if (_ruta == null) {
      mostrarMensaje(context, 'Elige primero tu ruta');
      return;
    }
    if (!await Geolocator.isLocationServiceEnabled()) {
      if (mounted) mostrarMensaje(context, 'Activa el GPS del teléfono');
      return;
    }
    var permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) permiso = await Geolocator.requestPermission();
    if (permiso == LocationPermission.denied || permiso == LocationPermission.deniedForever) {
      if (mounted) mostrarMensaje(context, 'Necesitas permitir el acceso a la ubicación');
      return;
    }

    final LocationSettings ajustes = defaultTargetPlatform == TargetPlatform.android
        ? AndroidSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 5,
            intervalDuration: const Duration(seconds: 4),
            foregroundNotificationConfig: const ForegroundNotificationConfig(
              notificationTitle: 'WebBus',
              notificationText: 'Compartiendo tu ubicación con los pasajeros',
              enableWakeLock: true,
            ),
          )
        : const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5);

    setState(() {
      _envios = 0;
      _sub = Geolocator.getPositionStream(locationSettings: ajustes).listen(
        _enviar,
        onError: (_) {
          _detener();
          if (mounted) mostrarMensaje(context, 'Se perdió la señal del GPS');
        },
      );
    });
  }

  Future<void> _enviar(Position pos) async {
    final ruta = _ruta;
    if (ruta == null) return;
    if (mounted) {
      setState(() {
        _ultima = pos;
        _envios++;
      });
    }
    try {
      await _doc.set({
        'activo': true,
        'conductor': widget.perfil.nombre,
        'rutaId': ruta.id,
        'rutaNombre': ruta.nombre,
        'empresa': ruta.empresa,
        'lat': pos.latitude,
        'lng': pos.longitude,
        'velocidad': pos.speed < 0 ? 0 : pos.speed,
        'rumbo': pos.heading,
        'actualizado': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      if (mounted) mostrarMensaje(context, 'No se pudo enviar la ubicación. Revisa tu conexión.');
    }
  }

  Future<void> _detener() async {
    await _sub?.cancel();
    if (mounted) setState(() => _sub = null);
    try {
      await _doc.delete();
    } catch (_) {}
  }

  Future<void> _salir() async {
    if (_activo) await _detener();
    await AuthService.salir();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(22, MediaQuery.of(context).padding.top + 18, 22, 28),
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
                Row(
                  children: [
                    const LogoWebBus(tam: 36, sombra: false),
                    const SizedBox(width: 10),
                    const Text('Modo conductor',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Cerrar sesión',
                      onPressed: _salir,
                      icon: const Icon(Icons.logout_rounded, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text('Hola, ${widget.perfil.nombre.split(' ').first} 👋',
                    style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                const Text('Comparte tu recorrido con los pasajeros',
                    style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(22),
              children: [
                StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance.collection('rutas').orderBy('nombre').snapshots(),
                  builder: (context, snap) {
                    final rutas = (snap.data?.docs ?? []).map(Ruta.desde).toList();
                    if (snap.hasData && rutas.isEmpty) {
                      return const Text('Aún no hay rutas. Pídele al administrador que cree una.',
                          textAlign: TextAlign.center);
                    }
                    return DropdownButtonFormField<String>(
                      initialValue: _ruta?.id,
                      decoration: const InputDecoration(
                        labelText: 'Tu ruta',
                        prefixIcon: Icon(Icons.alt_route_rounded, color: colorAzul),
                      ),
                      items: [
                        for (final r in rutas)
                          DropdownMenuItem(value: r.id, child: Text('${r.nombre} · ${r.empresa}')),
                      ],
                      onChanged: _activo
                          ? null
                          : (id) => setState(() => _ruta = rutas.firstWhere((r) => r.id == id)),
                    );
                  },
                ),
                const SizedBox(height: 36),
                Center(
                  child: GestureDetector(
                    onTap: _activo ? _detener : _iniciar,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _activo
                              ? [const Color(0xFFFF6B6B), const Color(0xFFD62828)]
                              : [const Color(0xFF7ED957), const Color(0xFF2E9E3A)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: (_activo ? Colors.red : colorVerde).withValues(alpha: 0.4),
                            blurRadius: 30,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_activo ? Icons.stop_rounded : Icons.play_arrow_rounded,
                              color: Colors.white, size: 70),
                          Text(_activo ? 'Terminar' : 'Iniciar recorrido',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (_activo)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: [BoxShadow(color: colorOscuro.withValues(alpha: 0.08), blurRadius: 16)],
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.circle, color: colorVerde, size: 12),
                            SizedBox(width: 8),
                            Text('Transmitiendo tu ubicación',
                                style: TextStyle(fontWeight: FontWeight.w800, color: colorOscuro)),
                          ],
                        ),
                        const Divider(height: 24),
                        _dato('Velocidad',
                            '${((_ultima?.speed ?? 0) * 3.6).clamp(0, 300).round()} km/h'),
                        _dato('Envíos', '$_envios'),
                        if (_ultima != null)
                          _dato('Posición',
                              '${_ultima!.latitude.toStringAsFixed(5)}, ${_ultima!.longitude.toStringAsFixed(5)}'),
                      ],
                    ),
                  )
                else
                  const Text(
                    'Elige tu ruta y pulsa el botón. Los pasajeros verán tu bus en el mapa en tiempo real.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dato(String t, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(t, style: const TextStyle(color: Colors.black54)),
            Text(v, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      );
}
