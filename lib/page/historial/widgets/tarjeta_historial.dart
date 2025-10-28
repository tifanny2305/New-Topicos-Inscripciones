import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/models/historial.dart';

class HistorialTarjeta extends StatelessWidget {
  final Historial item;

  const HistorialTarjeta({
    Key? key,
    required this.item,
  }) : super(key: key);

  // Determina el color del indicador de nota (verde para aprobado, rojo/naranja para reprobado)
  Color _getColorNota(double nota) {
    // Asumiendo que 51 es la nota mínima de aprobación
    if (nota >= 51.0) {
      return Colors.green.shade600;
    } else if (nota >= 40.0) {
      return Colors.orange.shade600;
    } else {
      return Colors.red.shade600;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Formateo de la nota a 1 decimal
    final notaFormateada = item.nota.toStringAsFixed(1);
    final colorNota = _getColorNota(item.nota);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        // Borde sutil para mejor definición
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Indicador de Nota (circular)
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: colorNota,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                notaFormateada,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 16),
            
            // Detalles de la Materia
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre de la Materia
                  Text(
                    item.materia,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  
                  // Info del grupo
                  _infoChip(
                    'Grupo ${item.grupoId}',
                    Icons.group,
                    Colors.blueGrey.shade100,
                    Colors.blueGrey.shade700,
                  ),
                ],
              ),
            ),
            
            // Estado (al final)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Muestra si está aprobado o reprobado
                const SizedBox(height: 8),
                 Text(
                  item.nota >= 51.0 ? 'APROBADO' : 'REPROBADO',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: colorNota,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para crear etiquetas informativas (chips)
  Widget _infoChip(String text, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
}