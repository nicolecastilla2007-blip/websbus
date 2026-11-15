import 'package:flutter/material.dart';

import 'empresas_tab.dart';
import 'inicio_tab.dart';
import 'paradas_tab.dart';

/// Pantalla principal con barra de navegación inferior (Inicio, Rutas, Paradas).
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indice = 0;
  // El mapa pide permiso de ubicación: solo se construye al abrir su pestaña.
  final _visitadas = <int>{0};

  void _ir(int i) => setState(() {
        _indice = i;
        _visitadas.add(i);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indice,
        children: [
          InicioTab(onIrA: _ir),
          _visitadas.contains(1) ? const EmpresasTab() : const SizedBox.shrink(),
          _visitadas.contains(2) ? const ParadasTab() : const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: _ir,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.alt_route_outlined),
            selectedIcon: Icon(Icons.alt_route_rounded),
            label: 'Rutas',
          ),
          NavigationDestination(
            icon: Icon(Icons.place_outlined),
            selectedIcon: Icon(Icons.place_rounded),
            label: 'Paradas',
          ),
        ],
      ),
    );
  }
}
