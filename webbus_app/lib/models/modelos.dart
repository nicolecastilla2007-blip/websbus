import 'package:cloud_firestore/cloud_firestore.dart';

class Perfil {
  final String uid;
  final String nombre;
  final String correo;
  final String rol; // pasajero | conductor | admin

  const Perfil({required this.uid, required this.nombre, required this.correo, required this.rol});

  factory Perfil.desde(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return Perfil(
      uid: doc.id,
      nombre: (d['nombre'] ?? '') as String,
      correo: (d['correo'] ?? '') as String,
      rol: (d['rol'] ?? 'pasajero') as String,
    );
  }
}

class Ruta {
  final String id;
  final String nombre;
  final String empresa;

  const Ruta({required this.id, required this.nombre, required this.empresa});

  factory Ruta.desde(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    return Ruta(id: doc.id, nombre: (d['nombre'] ?? '') as String, empresa: (d['empresa'] ?? '') as String);
  }
}

class BusActivo {
  final String uid;
  final String conductor;
  final String rutaId;
  final String rutaNombre;
  final String empresa;
  final double lat;
  final double lng;
  final double velocidadKmh;
  final DateTime? actualizado;

  const BusActivo({
    required this.uid,
    required this.conductor,
    required this.rutaId,
    required this.rutaNombre,
    required this.empresa,
    required this.lat,
    required this.lng,
    required this.velocidadKmh,
    required this.actualizado,
  });

  factory BusActivo.desde(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data();
    final ts = d['actualizado'];
    return BusActivo(
      uid: doc.id,
      conductor: (d['conductor'] ?? '') as String,
      rutaId: (d['rutaId'] ?? '') as String,
      rutaNombre: (d['rutaNombre'] ?? '') as String,
      empresa: (d['empresa'] ?? '') as String,
      lat: (d['lat'] as num).toDouble(),
      lng: (d['lng'] as num).toDouble(),
      velocidadKmh: ((d['velocidad'] ?? 0) as num).toDouble() * 3.6,
      actualizado: ts is Timestamp ? ts.toDate() : null,
    );
  }

  /// Un bus sin señal hace más de 2 minutos se considera detenido.
  bool get vigente => actualizado == null || DateTime.now().difference(actualizado!).inMinutes < 2;
}
