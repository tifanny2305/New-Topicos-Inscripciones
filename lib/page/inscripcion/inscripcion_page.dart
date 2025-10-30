import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/models/inscripcion/inscripcion_request.dart';
import 'package:inscripcion_topicos/page/inscripcion/widgets/btn_inscribir.dart';
import 'package:inscripcion_topicos/page/inscripcion/widgets/resuemen_grupos.dart';
import 'package:provider/provider.dart';
import '../../providers/inscripcion_provider.dart';
import '../../providers/login_provider.dart';

class InscripcionPage extends StatelessWidget {
  final List<Map<String, dynamic>> gruposSeleccionados;

  const InscripcionPage({Key? key, required this.gruposSeleccionados})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirmar Inscripción',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ResumenGrupos(grupos: gruposSeleccionados),
          ),
          BotonInscribir(
            gruposSeleccionados: gruposSeleccionados,
            onInscribir: () => _confirmarInscripcion(context),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmarInscripcion(BuildContext context) async {
    final loginProvider = context.read<LoginProvider>();
    final inscripcionProvider = context.read<InscripcionProvider>();

    if (loginProvider.estudianteId == null) {
      _mostrarError(context, 'No se encontró información del estudiante');
      return;
    }

    final request = InscripcionRequest(
      estudianteId: loginProvider.estudianteId!,
      gestionId: 1,
      fecha: DateTime.now().toIso8601String(),
      grupos: gruposSeleccionados.map((g) => g['grupoId'] as int).toList(),
    );

    try {
      final transactionId = await inscripcionProvider.crearInscripcion(
        request,
        loginProvider.token!,
      );

      if (context.mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/estado-inscripcion',
          arguments: transactionId,
        );
      }
    } catch (e) {
      if (context.mounted) {
        _mostrarError(context, 'Error al crear inscripción: ${e.toString()}');
      }
    }
  }

  void _mostrarError(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}