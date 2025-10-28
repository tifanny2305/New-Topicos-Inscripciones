import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/models/grupo.dart';
import 'package:inscripcion_topicos/providers/grupo_provider.dart';

/// Widget de tarjeta para mostrar información de un grupo
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
    final estaSeleccionado = materiaConGrupos.grupoSeleccionadoId == grupo.id;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: estaSeleccionado ? 3 : 1,
      color: estaSeleccionado ? Colors.blue.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: estaSeleccionado ? Colors.blue.shade200 : Colors.grey.shade200,
          width: estaSeleccionado ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _seleccionarGrupo(),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _construirEncabezadoGrupo(estaSeleccionado),
                    const SizedBox(height: 8),
                    _construirInformacionDocente(),
                    const SizedBox(height: 4),
                    _construirHorarios(),
                    const SizedBox(height: 8),
                    _construirCupos(estaSeleccionado),
                  ],
                ),
              ),
              Radio<int>(
                value: grupo.id,
                groupValue: materiaConGrupos.grupoSeleccionadoId,
                onChanged: (_) => _seleccionarGrupo(),
                activeColor: Colors.blue,
                toggleable: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construye el encabezado con la sigla del grupo
  Widget _construirEncabezadoGrupo(bool estaSeleccionado) {
    return Text(
      'Grupo ${grupo.sigla}',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: estaSeleccionado ? Colors.blue.shade900 : Colors.black87,
      ),
    );
  }

  /// Construye la información del docente
  Widget _construirInformacionDocente() {
    if (grupo.docente == null) return const SizedBox.shrink();

    return Row(
      children: [
        Icon(Icons.person, size: 14, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            grupo.docente!.nombre,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Construye la lista de horarios
  Widget _construirHorarios() {
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
      children: grupo.horarios.map((horario) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Row(
            children: [
              Icon(Icons.access_time, size: 12, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                '${horario.dia}: ${_formatearHora(horario.horaInicio)} - ${_formatearHora(horario.horaFin)}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// Construye la información de cupos disponibles
  Widget _construirCupos(bool estaSeleccionado) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: estaSeleccionado ? Colors.blue.shade100 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.people,
            size: 12,
            color: estaSeleccionado ? Colors.blue.shade700 : Colors.grey.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            '${grupo.cupo} cupos disponibles',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: estaSeleccionado ? Colors.blue.shade700 : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  /// Formatea la hora eliminando segundos
  String _formatearHora(String hora) {
    return hora.substring(0, 5);
  }

  /// Selecciona o deselecciona el grupo
  void _seleccionarGrupo() {
    provider.seleccionarGrupo(materiaConGrupos.materia.id, grupo.id);
  }
}