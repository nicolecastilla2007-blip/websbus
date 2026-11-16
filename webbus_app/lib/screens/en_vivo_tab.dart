import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/modelos.dart';
import '../theme.dart';
import '../widgets/buses_mapa.dart';

class EnVivoTab extends StatefulWidget {
  const EnVivoTab({super.key});

  @override
  State<EnVivoTab> createState() => _EnVivoTabState();
}

class _EnVivoTabState extends State<EnVivoTab> {
  String? _rutaId;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BusesMapa(rutaId: _rutaId),
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 46,
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance.collection('rutas').orderBy('nombre').snapshots(),
              builder: (context, snap) {
                final rutas = (snap.data?.docs ?? []).map(Ruta.desde).toList();
                return ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _chip('Todas', _rutaId == null, () => setState(() => _rutaId = null)),
                    for (final r in rutas)
                      _chip(r.nombre, _rutaId == r.id, () => setState(() => _rutaId = r.id)),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _chip(String texto, bool activo, VoidCallback onTap) => Padding(
        padding: const EdgeInsets.only(right: 8),
        child: ChoiceChip(
          label: Text(texto),
          selected: activo,
          onSelected: (_) => onTap(),
          selectedColor: colorAzul,
          backgroundColor: Colors.white,
          elevation: 3,
          labelStyle: TextStyle(
            color: activo ? Colors.white : colorOscuro,
            fontWeight: FontWeight.w700,
          ),
          showCheckmark: false,
        ),
      );
}
