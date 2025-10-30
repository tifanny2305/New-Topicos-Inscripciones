import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/page/historial/widgets/tarjeta_historial.dart';
import 'package:inscripcion_topicos/widgets/vista_error.dart';
import 'package:provider/provider.dart';
import '../../../providers/historial_provider.dart';
import '../../../providers/login_provider.dart';
import '../../widgets/barra_inferior.dart';

class HistorialPage extends StatefulWidget {
  const HistorialPage({Key? key}) : super(key: key);

  @override
  State<HistorialPage> createState() => _HistorialPageState();
}

class _HistorialPageState extends State<HistorialPage> {
  @override
  void initState() {
    super.initState();
    _cargarHistorialInicialmente();
  }

  void _cargarHistorialInicialmente() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final historialProvider = Provider.of<HistorialProvider>(
        context,
        listen: false,
      );

      final estudianteId = loginProvider.estudianteId;
      final token = loginProvider.token;

      if (estudianteId != null && token != null) {
        await historialProvider.cargarHistorial(estudianteId, token);
      } else {
        print('Error: Estudiante ID o Token es nulo. Redirigiendo a Login.');
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  Widget _resumenPromedio(HistorialProvider provider) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(bottom: BorderSide(color: Colors.blue.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Promedio General:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          Text(
            provider.promedioGeneral.toStringAsFixed(2),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: Colors.blue.shade700,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Historial', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      body: Consumer<HistorialProvider>(
        builder: (context, provider, child) {
          
          if (provider.estaCargando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return VistaErrorWidget(
              mensajeError: provider.error!,
              onReintentar: () => provider.reintentarCargaHistorias(context),
            );
          }

          if (provider.historial.isEmpty) {
            return const Center(
              child: Text(
                'No se encontró historial académico.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Vista principal con el resumen y la lista
          return Column(
            children: [
              // Resumen del Promedio
              _resumenPromedio(provider),

              // Lista de registros del historial
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.historialOrdenado.length,
                  itemBuilder: (context, index) => HistorialTarjeta(
                    item: provider.historialOrdenado[index], 
                  ),
                ),
              ),
            ],
          );
        },
      ),
      
      // BottomNavigationBar aquí dentro del Scaffold
      bottomNavigationBar: const BarraInferior(indiceActual: 1),
    );
  }
}