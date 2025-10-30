import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/inscripcion_provider.dart';

class BotonInscribir extends StatelessWidget {
  final List<Map<String, dynamic>> gruposSeleccionados;
  final VoidCallback onInscribir;

  const BotonInscribir({
    Key? key,
    required this.gruposSeleccionados,
    required this.onInscribir,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildResumen(),
            const SizedBox(height: 12),
            _buildBoton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildResumen() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${gruposSeleccionados.length} materia${gruposSeleccionados.length != 1 ? "s" : ""}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const Text(
          'Listo para inscribir',
          style: TextStyle(
            fontSize: 12,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildBoton(BuildContext context) {
    return Consumer<InscripcionProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: provider.cargando ? null : onInscribir,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: provider.cargando
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Confirmar Inscripción',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }
}