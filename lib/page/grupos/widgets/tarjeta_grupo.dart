import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/models/grupo.dart';
import 'package:inscripcion_topicos/providers/grupo_provider.dart';

class TarjetaGrupo extends StatelessWidget {
  final Grupo grupo;
  final MateriaConGrupos materiaConGrupos;
  final GrupoProvider provider;

  const TarjetaGrupo({
    Key? key,
    required this.grupo,
    required this.materiaConGrupos,
    required this.provider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final seleccionado = materiaConGrupos.grupoSeleccionadoId == grupo.id;
    final disponible = grupo.cupo > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: seleccionado ? 3 : 1,
      color: _getColorFondo(seleccionado, disponible),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getColorBorde(seleccionado, disponible),
          width: seleccionado ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: disponible ? () => _onTap() : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitulo(seleccionado, disponible),
                    const SizedBox(height: 8),
                    _buildDocente(),
                    const SizedBox(height: 4),
                    _buildHorarios(),
                    const SizedBox(height: 8),
                    _buildCupos(seleccionado, disponible),
                  ],
                ),
              ),
              Radio<int>(
                value: grupo.id,
                groupValue: materiaConGrupos.grupoSeleccionadoId,
                onChanged: disponible ? (_) => _onTap() : null,
                activeColor: Colors.blue,
                toggleable: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorFondo(bool seleccionado, bool disponible) {
    if (seleccionado) return Colors.blue.shade50;
    if (!disponible) return Colors.red.shade50;
    return Colors.white;
  }

  Color _getColorBorde(bool seleccionado, bool disponible) {
    if (!disponible) return Colors.red.shade100;
    if (seleccionado) return Colors.blue.shade200;
    return Colors.grey.shade200;
  }

  Widget _buildTitulo(bool seleccionado, bool disponible) {
    return Text(
      'Grupo ${grupo.sigla}',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: disponible
            ? (seleccionado ? Colors.blue.shade900 : Colors.black87)
            : Colors.grey,
      ),
    );
  }

  Widget _buildDocente() {
    if (grupo.docente == null) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(Icons.person, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            grupo.docente!.nombre,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildHorarios() {
    if (grupo.horarios.isEmpty) {
      return Text(
        'Sin horarios definidos',
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade500,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grupo.horarios.map((h) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            children: [
              Icon(Icons.access_time, size: 12, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${h.dia}: ${h.horaInicio.substring(0, 5)} - ${h.horaFin.substring(0, 5)}',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCupos(bool seleccionado, bool disponible) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: disponible
            ? (seleccionado ? Colors.blue.shade100 : Colors.grey.shade100)
            : Colors.red.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            disponible ? Icons.people : Icons.do_not_disturb_on_outlined,
            size: 12,
            color: disponible
                ? (seleccionado ? Colors.blue.shade700 : Colors.grey.shade700)
                : Colors.red.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            disponible ? '${grupo.cupo} cupos disponibles' : 'Sin cupos disponibles',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: disponible
                  ? (seleccionado ? Colors.blue.shade700 : Colors.grey.shade700)
                  : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }

  void _onTap() {
    provider.seleccionarGrupo(materiaConGrupos.materia.id, grupo.id);
  }
}