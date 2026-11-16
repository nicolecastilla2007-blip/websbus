import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/modelos.dart';
import '../theme.dart';

/// Mapa con los buses que están transmitiendo su ubicación en este momento.
class BusesMapa extends StatelessWidget {
  final String? rutaId;

  const BusesMapa({super.key, this.rutaId});

  static const centro = LatLng(10.9685, -74.7813);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('buses_activos')
          .where('activo', isEqualTo: true)
          .snapshots(),
      builder: (context, snap) {
        final buses = (snap.data?.docs ?? [])
            .map(BusActivo.desde)
            .where((b) => b.vigente && (rutaId == null || b.rutaId == rutaId))
            .toList();

        return Stack(
          children: [
            FlutterMap(
              options: const MapOptions(initialCenter: centro, initialZoom: 13),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.webbus.app',
                ),
                MarkerLayer(markers: [
                  for (final b in buses)
                    Marker(
                      point: LatLng(b.lat, b.lng),
                      width: 50,
                      height: 50,
                      child: GestureDetector(
                        onTap: () => _detalle(context, b),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colorVerde,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(Icons.directions_bus_rounded, color: Colors.white, size: 26),
                        ),
                      ),
                    ),
                ]),
                const RichAttributionWidget(
                  alignment: AttributionAlignment.bottomLeft,
                  attributions: [TextSourceAttribution('© OpenStreetMap contributors')],
                ),
              ],
            ),
            Positioned(
              right: 16,
              bottom: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 10)],
                ),
                child: Text(
                  buses.isEmpty ? 'Sin buses en circulación' : '${buses.length} bus(es) en vivo',
                  style: const TextStyle(fontWeight: FontWeight.w700, color: colorOscuro),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _detalle(BuildContext context, BusActivo b) {
    final hace = b.actualizado == null ? 0 : DateTime.now().difference(b.actualizado!).inSeconds;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(color: colorVerde, borderRadius: BorderRadius.circular(16)),
                  child: const Icon(Icons.directions_bus_rounded, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.rutaNombre,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: colorOscuro)),
                      Text(b.empresa, style: const TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _fila(Icons.person_outline_rounded, 'Conductor', b.conductor),
            _fila(Icons.speed_rounded, 'Velocidad', '${b.velocidadKmh.round()} km/h'),
            _fila(Icons.update_rounded, 'Actualizado', 'hace $hace s'),
          ],
        ),
      ),
    );
  }

  Widget _fila(IconData icono, String titulo, String valor) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Icon(icono, color: colorAzul, size: 20),
            const SizedBox(width: 10),
            Text('$titulo: ', style: const TextStyle(color: Colors.black54)),
            Expanded(child: Text(valor, style: const TextStyle(fontWeight: FontWeight.w600))),
          ],
        ),
      );
}
