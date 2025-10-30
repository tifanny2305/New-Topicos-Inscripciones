import 'package:flutter/material.dart';

class ResumenGrupos extends StatelessWidget {
  final List<Map<String, dynamic>> grupos;

  const ResumenGrupos({Key? key, required this.grupos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildEncabezado(),
        const SizedBox(height: 16),
        ...grupos.map((g) => _TarjetaGrupoResumen(grupo: g)),
      ],
    );
  }

  Widget _buildEncabezado() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Materias y Grupos Seleccionados',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${grupos.length} materia${grupos.length != 1 ? "s" : ""} seleccionada${grupos.length != 1 ? "s" : ""}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _TarjetaGrupoResumen extends StatelessWidget {
  final Map<String, dynamic> grupo;

  const _TarjetaGrupoResumen({required this.grupo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildChip(grupo['materiaSigla'], Colors.blue),
                const SizedBox(width: 8),
                _buildChip('Grupo ${grupo['grupoSigla']}', Colors.green),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              grupo['materiaNombre'],
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (grupo['docente'] != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    grupo['docente']['nombre'],
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
            if (grupo['horarios'] != null && grupo['horarios'].isNotEmpty) ...[
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              ...(grupo['horarios'] as List).map((h) => _buildHorario(h)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String text, MaterialColor color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.shade100,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color.shade700,
        ),
      ),
    );
  }

  Widget _buildHorario(Map<String, dynamic> horario) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(Icons.access_time, size: 12, color: Colors.grey.shade600),
          const SizedBox(width: 4),
          Text(
            '${horario['dia']}: ${_formatHora(horario['horaInicio'])} - ${_formatHora(horario['horaFin'])}',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
          ),
          if (horario['aula'] != null) ...[
            const SizedBox(width: 8),
            Text(
              '• Aula ${horario['aula']}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ],
      ),
    );
  }

  String _formatHora(String hora) => hora.substring(0, 5);
}