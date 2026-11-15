import 'package:flutter/material.dart';

import '../theme.dart';

void mostrarMensaje(BuildContext context, String texto) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(texto),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
}

/// Campo de texto con icono; si es contraseña, incluye el botón de ver/ocultar.
class CampoTexto extends StatefulWidget {
  final String etiqueta;
  final IconData icono;
  final TextEditingController? controller;
  final bool esClave;
  final TextInputType? teclado;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;

  const CampoTexto({
    super.key,
    required this.etiqueta,
    required this.icono,
    this.controller,
    this.esClave = false,
    this.teclado,
    this.validator,
    this.onSubmitted,
  });

  @override
  State<CampoTexto> createState() => _CampoTextoState();
}

class _CampoTextoState extends State<CampoTexto> {
  bool _oculto = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.esClave && _oculto,
      keyboardType: widget.teclado,
      validator: widget.validator,
      onFieldSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        labelText: widget.etiqueta,
        prefixIcon: Icon(widget.icono, color: colorAzul),
        suffixIcon: widget.esClave
            ? IconButton(
                icon: Icon(_oculto ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                onPressed: () => setState(() => _oculto = !_oculto),
              )
            : null,
      ),
    );
  }
}

String? validarCorreo(String? v) =>
    (v == null || !v.contains('@') || !v.contains('.')) ? 'Ingresa un correo válido' : null;

String? validarObligatorio(String? v) =>
    (v == null || v.trim().isEmpty) ? 'Este campo es obligatorio' : null;

/// Aparece con un desvanecido y un pequeño desplazamiento hacia arriba.
class Aparecer extends StatelessWidget {
  final Widget child;
  final int indice;

  const Aparecer({super.key, required this.child, this.indice = 0});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 450 + indice * 90),
      curve: Curves.easeOutCubic,
      builder: (context, v, hijo) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, 24 * (1 - v)), child: hijo),
      ),
      child: child,
    );
  }
}
