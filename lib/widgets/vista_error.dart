import 'package:flutter/material.dart';

class VistaErrorWidget extends StatelessWidget {
  final String mensajeError;
  final VoidCallback onReintentar;

  const VistaErrorWidget({
    Key? key,
    required this.mensajeError,
    required this.onReintentar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono de alerta para un mejor feedback visual
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 40,
          ),
          const SizedBox(height: 16),
          Text(
            'Error al cargar: $mensajeError',
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          // 🔁 Botón de reintento
          ElevatedButton.icon(
            onPressed: onReintentar,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}