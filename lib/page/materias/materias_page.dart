import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/page/materias/widgets/btn_continuar.dart';
import 'package:inscripcion_topicos/page/materias/widgets/filtros_materia.dart';
import 'package:inscripcion_topicos/page/materias/widgets/seleccion_resumen.dart';
import 'package:inscripcion_topicos/page/materias/widgets/tarjeta_materia.dart';
import 'package:inscripcion_topicos/providers/login_provider.dart';
import 'package:inscripcion_topicos/providers/materia_provider.dart';
import 'package:inscripcion_topicos/widgets/barra_inferior.dart';
import 'package:inscripcion_topicos/widgets/barra_superior.dart';
import 'package:provider/provider.dart';

class MateriasPage extends StatefulWidget {
  const MateriasPage({Key? key}) : super(key: key);

  @override
  State<MateriasPage> createState() => _MateriasPageState();
}

class _MateriasPageState extends State<MateriasPage> {
  @override
  void initState() {
    super.initState();
    _cargarInicialmente();
  }

  void _cargarInicialmente() {

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final loginProvider = Provider.of<LoginProvider>(context, listen: false);
      final materiaProvider = Provider.of<MateriaProvider>(context, listen: false);

      final estudianteId = loginProvider.estudianteId;
      final token = loginProvider.token;

      // Verificar ID y Token
      if (estudianteId != null && token != null) {

        //Llamar al provider con el ID y el Token
        await materiaProvider.cargarMaterias(estudianteId, token); 

      } else {
        print('Error: Estudiante ID o Token es nulo. Redirigiendo a Login.');
        Navigator.pushReplacementNamed(context, '/'); 
      }
    });
  }

  // Método auxiliar para construir la vista de error
  Widget _construirVistaError(MateriaProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error al cargar: ${provider.error}',
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
            final loginProvider = context.read<LoginProvider>();
            if (loginProvider.estudianteId != null) {
              await provider.cargarMaterias(
                loginProvider.estudianteId!, 
                loginProvider.token!,
              );
            }
          },
          child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: const BarraSuperior(), 
      
      body: Consumer<MateriaProvider>(
        builder: (context, provider, child) {
          // Usamos el getter en español
          if (provider.estaCargando) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return _construirVistaError(provider);
          }

          return Column(
            children: [
              FiltrosMateriaWidget(provider: provider), 
              
              if (provider.materiasSeleccionadas.isNotEmpty)
                ResumenSeleccionWidget(provider: provider),
              Expanded(
                child: provider.materiasFiltradas.isEmpty
                    ? const Center(child: Text('No se encontraron materias.'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.materiasFiltradas.length,
                        itemBuilder: (context, index) => TarjetaMateria(
                          materia: provider.materiasFiltradas[index],
                          provider: provider,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Consumer<MateriaProvider>(
            builder: (context, provider, child) {
              return BotonContinuarWidget(provider: provider);
            },
          ),
          // BottomNavigationBar aquí dentro del Scaffold
          const BarraInferior(indiceActual: 0),
        ],
      ),
    );
  }
}