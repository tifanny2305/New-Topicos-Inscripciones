import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/providers/inscripcion_provider.dart';
import 'package:provider/provider.dart';

class NotificacionesPage extends StatelessWidget {
  const NotificacionesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<InscripcionProvider>(
        builder: (context, provider, _) {
          if (provider.transacciones.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('Sin notificaciones', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.transacciones.length,
            itemBuilder: (context, index) => _buildTarjeta(context, provider.transacciones[index], index + 1),
          );
        },
      ),
    );
  }

  Widget _buildTarjeta(BuildContext context, TransaccionInfo t, int num) {
    final color = t.error != null ? Colors.red : t.esProcesando ? Colors.orange : t.esExitoso ? Colors.green : Colors.red;
    final icono = t.error != null ? Icons.error : t.esProcesando ? Icons.sync : t.esExitoso ? Icons.check_circle : Icons.cancel;
    final titulo = t.error != null ? 'Error' : t.esProcesando ? 'Procesando...' : t.esExitoso ? 'Completada' : 'Fallida';
    final mensaje = t.error ?? (t.esProcesando ? 'En cola' : t.esExitoso ? 'ID: ${t.estadoActual?.inscripcionId}' : 'No completada');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        // ✅ CAMBIO: Siempre navega a estado-inscripcion
        onTap: () {
          Navigator.pushNamed(
            context,
            '/estado-inscripcion',
            arguments: t.transactionId,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: color.withOpacity(0.2),
                    child: Text('$num', style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(titulo, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
                        Text(mensaje, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Icon(icono, color: color, size: 24),
                ],
              ),
              if (t.esProcesando) ...[
                const SizedBox(height: 12),
                LinearProgressIndicator(value: t.intentosPolling / 10, backgroundColor: Colors.grey.shade200, color: color, minHeight: 4),
                const SizedBox(height: 4),
                Text('${t.intentosPolling}/10', style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}