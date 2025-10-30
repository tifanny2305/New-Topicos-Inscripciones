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
    final sinCupos = grupo.cupo <= 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: seleccionado ? 3 : 1,
      color: sinCupos
          ? Colors.grey.shade50
          : (seleccionado ? Colors.blue.shade50 : Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: sinCupos
              ? Colors.red.shade200
              : (seleccionado ? Colors.blue.shade200 : Colors.grey.shade200),
          width: seleccionado ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => _onTap(context, seleccionado, sinCupos),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Grupo ${grupo.sigla}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: sinCupos ? Colors.grey : Colors.black87,
                          ),
                        ),
                        if (grupo.docente != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 14,
                                color: Colors.grey.shade600,
                              ),
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
                          ),
                        ],
                        const SizedBox(height: 4),
                        ...grupo.horarios.map(
                          (h) => Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 12,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${h.dia}: ${h.horaInicio.substring(0, 5)} - ${h.horaFin.substring(0, 5)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: sinCupos
                                ? Colors.red.shade100
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                sinCupos ? Icons.block : Icons.people,
                                size: 12,
                                color: sinCupos
                                    ? Colors.red.shade700
                                    : Colors.grey.shade700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                sinCupos ? 'Sin cupos' : '${grupo.cupo} cupos',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: sinCupos
                                      ? Colors.red.shade700
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Radio<int>(
                    value: grupo.id,
                    groupValue: materiaConGrupos.grupoSeleccionadoId,
                    onChanged: (_) => _onTap(context, seleccionado, sinCupos),
                    activeColor: sinCupos ? Colors.red : Colors.blue,
                    toggleable: true,
                  ),
                ],
              ),
              if (seleccionado && sinCupos) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.amber.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: Colors.amber.shade700,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Sin cupos disponibles. No podrás inscribirte.',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context, bool estabaSeleccionado, bool sinCupos) {
    provider.seleccionarGrupo(materiaConGrupos.materia.id, grupo.id);

    if (!estabaSeleccionado && sinCupos) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning_amber, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Grupo ${grupo.sigla} sin cupos'),
            ],
          ),
          backgroundColor: Colors.amber.shade700,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
