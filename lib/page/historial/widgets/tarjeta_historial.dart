import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/models/historial.dart';

class HistorialTarjeta extends StatelessWidget {
  final Historial item;

  const HistorialTarjeta({
    Key? key,
    required this.item,
  }) : super(key: key);

  static const double _notaAprobacion = 51.0;

  Color _getColorNota(double? nota) {
    if (nota == null) { 
      return Colors.blue.shade600;
    } else if (nota >= _notaAprobacion) {
      return Colors.green.shade600;
    } else {
      return Colors.red.shade600;
    }
  }

  // Define el texto para mostrar en el círculo de la nota
  String _getNotaText(double? nota) {
    if (nota == null) {
      return '- -';
    }
    return nota.toStringAsFixed(1);
  }

  String _getEstadoTexto(double? nota) {
    if (nota == null) {
      return 'EN CURSO';
    }
    return nota >= _notaAprobacion ? 'APROBADO' : 'REPROBADO';
  }

  @override
  Widget build(BuildContext context) {
    final notaTexto = _getNotaText(item.nota);
    final colorNota = _getColorNota(item.nota);
    final estadoTexto = _getEstadoTexto(item.nota);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
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
                notaTexto,
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
                  // Nombre de la Materia (Ajustado para no truncar)
                  Text(
                    item.materia,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                    maxLines: 2, 
                  ),
                ],
              ),
            ),
            
            // Estado (al final)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 8),
                 Text(
                  estadoTexto,
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
}