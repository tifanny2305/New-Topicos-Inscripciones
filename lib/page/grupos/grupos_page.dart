import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/models/materia.dart';
import 'package:inscripcion_topicos/page/grupos/widgets/btn_continuar.dart';
import 'package:inscripcion_topicos/providers/grupo_provider.dart';
import 'package:inscripcion_topicos/page/grupos/widgets/barra_progreso.dart';
import 'package:inscripcion_topicos/page/grupos/widgets/tarjeta_materia_grupo.dart';
import 'package:inscripcion_topicos/providers/login_provider.dart';
import 'package:provider/provider.dart';

/// Página para seleccionar grupos de las materias elegidas
class GruposPage extends StatefulWidget {
  final List<Materia> materias;

  const GruposPage({Key? key, required this.materias}) : super(key: key);

  @override
  State<GruposPage> createState() => _GruposPageState();
}

class _GruposPageState extends State<GruposPage> {
  @override
  void initState() {
    super.initState();
    _cargarGruposInicial();
  }

  /// Carga los grupos disponibles para las materias seleccionadas
  void _cargarGruposInicial() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ← Agrega async aquí
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final grupoProvider = Provider.of<GrupoProvider>(context, listen: false);

      final estudianteId = loginProvider.estudianteId;
      final token = loginProvider.token;

      if (estudianteId != null && token != null) {
        await grupoProvider.cargarGrupos(widget.materias, token);
      } else {
        print('Error: Estudiante ID o Token es nulo. Redirigiendo a Login.');
        Navigator.pushReplacementNamed(context, '/');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seleccionar Grupos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer<GrupoProvider>(
        builder: (context, provider, child) {
          // Estado de carga
          if (provider.estaCargando) {
            return const Center(child: CircularProgressIndicator());
          }

          // Estado de error
          if (provider.error != null) {
            return _construirVistaError(provider);
          }

          // Vista principal con grupos
          return Column(
            children: [
              BarraProgreso(provider: provider),
              Expanded(child: _construirListaGrupos(provider)),
              BotonContinuar(provider: provider),
            ],
          );
        },
      ),
    );
  }

  /// Construye la vista cuando hay un error
  Widget _construirVistaError(GrupoProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red.shade400),
            const SizedBox(height: 16),
            Text(
              'Error al cargar grupos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              provider.error ?? 'Error desconocido',
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                final loginProvider = Provider.of<LoginProvider>(
                  context,
                  listen: false,
                );
                final token = loginProvider.token;
                if (token != null) {
                  provider.cargarGrupos(widget.materias, token);
                }
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Construye la lista de materias con sus grupos
  Widget _construirListaGrupos(GrupoProvider provider) {
    if (provider.materiasConGrupos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'No hay grupos disponibles',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.materiasConGrupos.length,
      itemBuilder: (context, indice) {
        final materiaConGrupos = provider.materiasConGrupos[indice];
        return TarjetaMateriaGrupo(
          materiaConGrupos: materiaConGrupos,
          provider: provider,
        );
      },
    );
  }
}
