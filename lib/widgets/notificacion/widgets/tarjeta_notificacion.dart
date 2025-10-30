import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/providers/inscripcion_provider.dart';

class TarjetaNotificacion extends StatelessWidget {
  final TransaccionInfo transaccion;
  final int numero;

  const TarjetaNotificacion({
    Key? key,
    required this.transaccion,
    required this.numero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = _obtenerColor();
    final icono = _obtenerIcono();
    final titulo = _obtenerTitulo();
    final mensaje = _obtenerMensaje();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navegarADetalle(context),  // ← Cambio aquí
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fila principal
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: color.withOpacity(0.2),
                    child: Text(
                      '$numero',
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          titulo,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                        Text(
                          mensaje,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(icono, color: color, size: 24),
                ],
              ),
              
              // Barra de progreso si está procesando
              if (transaccion.esProcesando) ...[
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: transaccion.intentosPolling / 10,
                  backgroundColor: Colors.grey.shade200,
                  color: color,
                  minHeight: 4,
                ),
                const SizedBox(height: 4),
                Text(
                  '${transaccion.intentosPolling}/10',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _obtenerColor() {
    if (transaccion.error != null) return Colors.red;
    if (transaccion.esProcesando) return Colors.orange;
    if (transaccion.esExitoso) return Colors.green;
    return Colors.red;
  }

  IconData _obtenerIcono() {
    if (transaccion.error != null) return Icons.error;
    if (transaccion.esProcesando) return Icons.sync;
    if (transaccion.esExitoso) return Icons.check_circle;
    return Icons.cancel;
  }

  String _obtenerTitulo() {
    if (transaccion.error != null) return 'Error';
    if (transaccion.esProcesando) return 'Procesando...';
    if (transaccion.esExitoso) return 'Completada';
    return 'Fallida';
  }

  String _obtenerMensaje() {
    if (transaccion.error != null) return transaccion.error!;
    if (transaccion.esProcesando) return 'En cola';
    if (transaccion.esExitoso) {
      return 'ID: ${transaccion.estadoActual?.inscripcionId ?? "N/A"}';
    }
    return 'No completada';
  }

  // ✅ NUEVO: Siempre navega a EstadoPage para ver el detalle
  void _navegarADetalle(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/estado-inscripcion',
      arguments: transaccion.transactionId,
    );
  }
}