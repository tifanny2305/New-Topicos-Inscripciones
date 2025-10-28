import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/providers/grupo_provider.dart';

/// Widget del botón para continuar a la inscripción
class BotonContinuar extends StatelessWidget {
  final GrupoProvider provider;

  const BotonContinuar({
    Key? key,
    required this.provider,
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
            _construirResumen(),
            const SizedBox(height: 12),
            _construirBoton(context),
          ],
        ),
      ),
    );
  }

  /// Construye el resumen de materias y selecciones
  Widget _construirResumen() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${provider.materiasConGrupos.length} materias',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          _obtenerTextoEstado(),
          style: TextStyle(
            fontSize: 12,
            color: _obtenerColorEstado(),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Construye el botón de continuar
  Widget _construirBoton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: provider.tieneAlMenosUnaSeleccionada
            ? () => _manejarContinuar(context)
            : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade600,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Continuar a inscripción',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Obtiene el texto del estado de selección
  String _obtenerTextoEstado() {
    if (provider.tieneAlMenosUnaSeleccionada) {
      return '${provider.materiasSeleccionadas} seleccionada(s)';
    }
    return 'Selecciona al menos un grupo';
  }

  /// Obtiene el color según el estado de selección
  Color _obtenerColorEstado() {
    return provider.tieneAlMenosUnaSeleccionada
        ? Colors.green
        : Colors.amber.shade700;
  }

  /// Maneja la acción de continuar
  void _manejarContinuar(BuildContext context) {
    final gruposSeleccionados = provider.obtenerGruposSeleccionados();
    Navigator.pushNamed(
      context,
      '/inscripcion',
      arguments: gruposSeleccionados,
    );
  }
}