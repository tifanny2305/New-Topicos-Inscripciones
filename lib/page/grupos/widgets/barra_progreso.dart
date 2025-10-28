import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/providers/grupo_provider.dart';

/// Widget que muestra el progreso de selección de grupos
class BarraProgreso extends StatelessWidget {
  final GrupoProvider provider;

  const BarraProgreso({
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _construirEncabezadoProgreso(),
          const SizedBox(height: 8),
          _construirBarraProgreso(),
          const SizedBox(height: 8),
          _construirTextoProgreso(),
        ],
      ),
    );
  }

  /// Construye el encabezado con el título y porcentaje
  Widget _construirEncabezadoProgreso() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Progreso de selección',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        Text(
          '${provider.progresoSeleccion}%',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.blue,
          ),
        ),
      ],
    );
  }

  /// Construye la barra de progreso visual
  Widget _construirBarraProgreso() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: LinearProgressIndicator(
        value: provider.progresoSeleccion / 100,
        backgroundColor: Colors.grey.shade200,
        color: Colors.blue,
        minHeight: 8,
      ),
    );
  }

  /// Construye el texto descriptivo del progreso
  Widget _construirTextoProgreso() {
    return Text(
      '${provider.materiasSeleccionadas} de ${provider.materiasConGrupos.length} materias con grupo seleccionado',
      style: TextStyle(
        fontSize: 12,
        color: Colors.grey.shade600,
      ),
    );
  }
}