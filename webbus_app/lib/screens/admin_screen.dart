import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/modelos.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import '../widgets/buses_mapa.dart';
import '../widgets/logo_webbus.dart';
import '../widgets/ui.dart';

class AdminScreen extends StatelessWidget {
  final Perfil perfil;

  const AdminScreen({super.key, required this.perfil});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorOscuro,
          foregroundColor: Colors.white,
          title: const Row(
            children: [
              LogoWebBus(tam: 28, sombra: false),
              SizedBox(width: 10),
              Text('Panel de administrador', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
            ],
          ),
          actions: [
            IconButton(
              tooltip: 'Cerrar sesión',
              onPressed: AuthService.salir,
              icon: const Icon(Icons.logout_rounded),
            ),
          ],
          bottom: const TabBar(
            indicatorColor: colorPrimario,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(icon: Icon(Icons.map_rounded), text: 'Buses'),
              Tab(icon: Icon(Icons.alt_route_rounded), text: 'Rutas'),
              Tab(icon: Icon(Icons.people_rounded), text: 'Usuarios'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const BusesMapa(),
            const _RutasAdmin(),
            _UsuariosAdmin(miUid: perfil.uid),
          ],
        ),
      ),
    );
  }
}

class _RutasAdmin extends StatelessWidget {
  const _RutasAdmin();

  Future<void> _nueva(BuildContext context) async {
    final nombre = TextEditingController();
    final empresa = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nueva ruta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nombre, decoration: const InputDecoration(labelText: 'Nombre (ej. Ruta 12)')),
            const SizedBox(height: 12),
            TextField(controller: empresa, decoration: const InputDecoration(labelText: 'Empresa')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Crear')),
        ],
      ),
    );
    if (ok == true && nombre.text.trim().isNotEmpty) {
      await FirebaseFirestore.instance.collection('rutas').add({
        'nombre': nombre.text.trim(),
        'empresa': empresa.text.trim(),
      });
    }
    nombre.dispose();
    empresa.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _nueva(context),
        backgroundColor: colorAzul,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva ruta'),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('rutas').orderBy('nombre').snapshots(),
        builder: (context, snap) {
          final rutas = (snap.data?.docs ?? []).map(Ruta.desde).toList();
          if (rutas.isEmpty) {
            return const Center(child: Text('Aún no hay rutas. Crea la primera.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            itemCount: rutas.length,
            separatorBuilder: (context, indice) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final r = rutas[i];
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: colorAzul,
                    child: Icon(Icons.alt_route_rounded, color: Colors.white),
                  ),
                  title: Text(r.nombre, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(r.empresa),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                    onPressed: () => FirebaseFirestore.instance.collection('rutas').doc(r.id).delete(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _UsuariosAdmin extends StatelessWidget {
  final String miUid;

  const _UsuariosAdmin({required this.miUid});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance.collection('users').orderBy('nombre').snapshots(),
      builder: (context, snap) {
        if (snap.hasError) return Center(child: Text('Error: ${snap.error}'));
        final docs = snap.data?.docs ?? [];
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          separatorBuilder: (context, indice) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final p = Perfil.desde(docs[i]);
            final yo = p.uid == miUid;
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: colorPrimario,
                  child: Text(p.nombre.isEmpty ? '?' : p.nombre[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                ),
                title: Text(p.nombre, style: const TextStyle(fontWeight: FontWeight.w700)),
                subtitle: Text(p.correo),
                trailing: DropdownButton<String>(
                  value: p.rol,
                  underline: const SizedBox.shrink(),
                  items: const [
                    DropdownMenuItem(value: 'pasajero', child: Text('Pasajero')),
                    DropdownMenuItem(value: 'conductor', child: Text('Conductor')),
                    DropdownMenuItem(value: 'admin', child: Text('Admin')),
                  ],
                  onChanged: yo
                      ? null
                      : (rol) => FirebaseFirestore.instance.collection('users').doc(p.uid).update({'rol': rol}),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
