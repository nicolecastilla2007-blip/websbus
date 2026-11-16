import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

String mensajeAuth(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-credential':
    case 'wrong-password':
    case 'user-not-found':
      return 'Correo o contraseña incorrectos';
    case 'invalid-email':
      return 'El correo no es válido';
    case 'email-already-in-use':
      return 'Ya existe una cuenta con ese correo';
    case 'weak-password':
      return 'La contraseña debe tener al menos 6 caracteres';
    case 'network-request-failed':
      return 'Sin conexión a internet';
    case 'too-many-requests':
      return 'Demasiados intentos. Espera un momento';
    default:
      return 'Error: ${e.message ?? e.code}';
  }
}

class AuthService {
  static final _auth = FirebaseAuth.instance;
  static final _db = FirebaseFirestore.instance;

  static Stream<User?> get sesion => _auth.authStateChanges();

  static Stream<DocumentSnapshot<Map<String, dynamic>>> perfil(String uid) =>
      _db.collection('users').doc(uid).snapshots();

  static Future<void> iniciarSesion(String correo, String clave) =>
      _auth.signInWithEmailAndPassword(email: correo, password: clave);

  static Future<void> registrar(String nombre, String correo, String clave) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: correo, password: clave);
    try {
      await _db.collection('users').doc(cred.user!.uid).set({
        'nombre': nombre,
        'correo': correo,
        'rol': 'pasajero',
        'creado': FieldValue.serverTimestamp(),
      });
    } catch (_) {
      await cred.user!.delete();
      rethrow;
    }
  }

  static Future<void> recuperar(String correo) => _auth.sendPasswordResetEmail(email: correo);

  static Future<void> salir() => _auth.signOut();
}
