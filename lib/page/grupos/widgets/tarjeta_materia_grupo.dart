import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/page/grupos/widgets/mensaje_sin%20grupo.dart';
import 'package:inscripcion_topicos/providers/grupo_provider.dart';
import 'package:inscripcion_topicos/page/grupos/widgets/tarjeta_grupo.dart';

/// Widget de tarjeta que muestra una materia con sus grupos disponibles
class TarjetaMateriaGrupo extends StatelessWidget {
  final MateriaConGrupos materiaConGrupos;
  final GrupoProvider provider;

  const TarjetaMateriaGrupo({
    Key? key,
    required this.materiaConGrupos,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _construirEncabezado(),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            _construirContenidoGrupos(),
          ],
        ),
      ),
    );
  }

  /// Construye el encabezado con información de la materia
  Widget _construirEncabezado() {
    final materia = materiaConGrupos.materia;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _construirEtiquetaSigla(materia.sigla),
            const SizedBox(width: 8),
            _construirEtiquetaTipo(materia.tipo.nombre),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          materia.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  /// Construye la etiqueta de sigla de la materia
  Widget _construirEtiquetaSigla(String sigla) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        sigla,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  /// Construye la etiqueta del tipo de materia
  Widget _construirEtiquetaTipo(String tipoNombre) {
    final esElectiva = tipoNombre.toLowerCase() == 'electiva';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: esElectiva ? Colors.amber.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        tipoNombre,
        style: TextStyle(
          color: esElectiva ? Colors.amber.shade900 : Colors.grey.shade700,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  /// Construye el contenido de grupos o mensaje vacío
  Widget _construirContenidoGrupos() {
    if (materiaConGrupos.grupos.isEmpty) {
      return const MensajeSinGrupos();
    }

    return Column(
      children: materiaConGrupos.grupos
          .map((grupo) => TarjetaGrupo(
                grupo: grupo,
                materiaConGrupos: materiaConGrupos,
                provider: provider,
              ))
          .toList(),
    );
  }
}