import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/page/perfil/widgets/encabezado.dart';
import 'package:inscripcion_topicos/page/perfil/widgets/tarjeta_detalle.dart';
import 'package:inscripcion_topicos/providers/login_provider.dart';
import 'package:inscripcion_topicos/providers/perfil_provider.dart';
import 'package:inscripcion_topicos/widgets/barra_inferior.dart';
import 'package:provider/provider.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  void initState() {
    super.initState();
    _cargarPerfilInicialmente();
  }

  /// Llama al provider para cargar el perfil usando el ID y Token del LoginProvider
  void _cargarPerfilInicialmente() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final perfilProvider = Provider.of<PerfilProvider>(
        context,
        listen: false,
      );

      final estudianteId = loginProvider.estudianteId;
      final token = loginProvider.token;

      if (estudianteId != null && token != null) {
        await perfilProvider.cargarPerfil(estudianteId, token);
      } else {
        // En caso de error crítico (no hay token/ID), redirigir a Login
        if (mounted) {
          loginProvider.cerrarSesion();
          Navigator.pushReplacementNamed(context, '/');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.blue.shade800,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<PerfilProvider>(
        builder: (context, provider, child) {
          if (provider.estaCargando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Error de carga: ${provider.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            );
          }

          final perfil = provider.perfil;
          if (perfil == null) {
            return const Center(
              child: Text('No se encontró información del perfil.'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Encabezado del perfil
                Encabezado(perfil: perfil),

                // Información de Contacto y Plan
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Datos de Contacto',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tarjeta Email
                      TarjetaDetalle(
                        icon: Icons.email,
                        title: 'Correo Electrónico',
                        subtitle: perfil.email,
                      ),

                      // Tarjeta Teléfono
                      TarjetaDetalle(
                        icon: Icons.phone,
                        title: 'Teléfono',
                        subtitle: perfil.telefono,
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        'Información Académica',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Tarjeta Plan de Estudio
                      TarjetaDetalle(
                        icon: Icons.assignment_ind,
                        title: 'Plan de Estudio',
                        subtitle: 'ID: ${perfil.plan_estudio_id}',
                      ),

                      // Tarjeta Código de Acceso
                      TarjetaDetalle(
                        icon: Icons.lock,
                        title: 'Código de Acceso',
                        subtitle: perfil.codigo,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      // BottomNavigationBar aquí dentro del Scaffold
      bottomNavigationBar: const BarraInferior(indiceActual: 2),
    );
  }
}
