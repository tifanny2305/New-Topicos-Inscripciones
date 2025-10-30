import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/inscripcion_provider.dart';
import 'widgets/estado_procesando.dart';
import 'widgets/estado_exitoso.dart';
import 'widgets/estado_error.dart';

class EstadoPage extends StatelessWidget {
  const EstadoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? transactionId = ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Estado de Inscripción',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<InscripcionProvider>(
        builder: (context, provider, _) {
          if (provider.cargando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (transactionId == null) {
            return const Center(
              child: Text('No se especificó una inscripción'),
            );
          }

          final transaccion = provider.transacciones.firstWhere(
            (t) => t.transactionId == transactionId,
            orElse: () => TransaccionInfo(
              transactionId: transactionId,
              error: 'Transacción no encontrada',
            ),
          );

          // Error en la transacción
          if (transaccion.error != null) {
            return EstadoError(
              mensaje: transaccion.error!,
              onReintentar: () => Navigator.pop(context),
            );
          }

          // Procesando
          if (transaccion.esProcesando) {
            return EstadoProcesando(
              transactionId: transaccion.transactionId,
              intentos: transaccion.intentosPolling,
              maxIntentos: 10,
            );
          }

          // Exitoso
          if (transaccion.esExitoso && transaccion.estadoActual?.inscripcionId != null) {
            return EstadoExitoso(
              inscripcionId: transaccion.estadoActual!.inscripcionId!,
            );
          }

          // Fallido
          return EstadoError(
            mensaje: 'La inscripción no se pudo completar',
            onReintentar: () => Navigator.pop(context),
          );
        },
      ),
    );
  }
}