import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/providers/login_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/inscripcion_provider.dart';
import 'widgets/estado_procesando.dart';
import 'widgets/estado_exitoso.dart';
import 'widgets/estado_error.dart';

class EstadoPage extends StatelessWidget {
  const EstadoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Estado de Inscripción',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              final token = context.read<LoginProvider>().token;
              if (token != null) {
                context.read<InscripcionProvider>().consultarEstado(token);
              }
            },
          ),
        ],
      ),
      body: Consumer<InscripcionProvider>(
        builder: (context, provider, _) {
          if (provider.cargando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return EstadoError(
              mensaje: provider.error!,
              onReintentar: () {
                final token = context.read<LoginProvider>().token;
                if (token != null) {
                  provider.consultarEstado(token);
                }
              },
            );
          }

          if (provider.estadoActual == null) {
            return const Center(child: Text('No hay inscripción en proceso'));
          }

          final estado = provider.estadoActual!;

          if (estado.esProcesando) {
            return EstadoProcesando(
              transactionId: provider.transactionId!,
              intentos: provider.intentosPolling,
              maxIntentos: 10,
            );
          }

          if (estado.esProcesado && estado.esExitoso) {
            return EstadoExitoso(inscripcionId: estado.inscripcionId!);
          }

          return EstadoError(
            mensaje: 'La inscripción no se pudo completar',
            onReintentar: () => Navigator.pop(context),
          );
        },
      ),
    );
  }
}
