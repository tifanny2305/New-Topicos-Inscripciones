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

  void _cargarPerfilInicialmente() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final perfilProvider = Provider.of<PerfilProvider>(context, listen: false);

      final estudianteId = loginProvider.estudianteId;
      final token = loginProvider.token;

      if (estudianteId != null && token != null) {
        await perfilProvider.cargarPerfil(estudianteId, token);
      } else {
        if (mounted) {
          loginProvider.cerrarSesion();
          Navigator.pushReplacementNamed(context, '/');
        }
      }
    });
  }

  Future<void> _confirmarCerrarSesion() async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );

    if (confirmar == true && mounted) {
      await context.read<LoginProvider>().cerrarSesion();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
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
                Encabezado(
                  perfil: perfil,
                  onLogout: _confirmarCerrarSesion,
                ),

                // Información de Contacto
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

                      TarjetaDetalle(
                        icon: Icons.email,
                        title: 'Correo Electrónico',
                        subtitle: perfil.email,
                      ),

                      TarjetaDetalle(
                        icon: Icons.phone,
                        title: 'Teléfono',
                        subtitle: perfil.telefono,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const BarraInferior(indiceActual: 3),
    );
  }
}