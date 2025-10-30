import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/page/grupos/widgets/dialogo_conflicto.dart';
import 'package:inscripcion_topicos/providers/grupo_provider.dart';

class BotonContinuar extends StatelessWidget {
  final GrupoProvider provider;

  const BotonContinuar({Key? key, required this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${provider.materiasConGrupos.length} materias',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  _texto(),
                  style: TextStyle(
                    fontSize: 12,
                    color: _color(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: provider.puedesContinuar
                    ? () => _continuar(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Continuar a inscripción',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _texto() {
    if (!provider.tieneAlMenosUnaSeleccionada)
      return 'Selecciona al menos un grupo';
    if (!provider.todosLosSeleccionadosTienenCupo) return 'Grupos sin cupos';
    return '${provider.materiasSeleccionadas} seleccionada(s)';
  }

  Color _color() {
    if (!provider.tieneAlMenosUnaSeleccionada) return Colors.amber.shade700;
    if (!provider.todosLosSeleccionadosTienenCupo) return Colors.red.shade700;
    return Colors.green;
  }

  void _continuar(BuildContext context) {
    final conflictos = _validar();
    if (conflictos.isEmpty) {
      _navegar(context);
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => DialogoConflictos(conflictos: conflictos),
    );
  }

  List<String> _validar() {
    final conflictos = <String>[];
    final sel = <Map<String, dynamic>>[];

    for (var m in provider.materiasConGrupos) {
      if (m.grupoSeleccionadoId != null) {
        sel.add({
          'n': m.materia.nombre,
          's': m.materia.sigla,
          'g': m.grupos.firstWhere((g) => g.id == m.grupoSeleccionadoId),
        });
      }
    }

    for (int i = 0; i < sel.length; i++) {
      for (int j = i + 1; j < sel.length; j++) {
        final n1 = sel[i]['n'] as String,
            s1 = sel[i]['s'] as String,
            g1 = sel[i]['g'];
        final n2 = sel[j]['n'] as String,
            s2 = sel[j]['s'] as String,
            g2 = sel[j]['g'];

        for (var h1 in g1.horarios) {
          for (var h2 in g2.horarios) {
            if (_choca(h1, h2)) {
              conflictos.add(
                '$s1 - $n1|Grupo ${g1.sigla}|$s2 - $n2|Grupo ${g2.sigla}|${h1.dia}: ${h1.horaInicio.substring(0, 5)} - ${h1.horaFin.substring(0, 5)}',
              );
            }
          }
        }
      }
    }
    return conflictos;
  }

  bool _choca(dynamic h1, dynamic h2) {
    if (h1.dia.toLowerCase() != h2.dia.toLowerCase()) return false;
    final i1 = _min(h1.horaInicio), f1 = _min(h1.horaFin);
    final i2 = _min(h2.horaInicio), f2 = _min(h2.horaFin);
    return i1 < f2 && f1 > i2;
  }

  int _min(String h) {
    final p = h.substring(0, 5).split(':');
    return int.parse(p[0]) * 60 + int.parse(p[1]);
  }

  void _navegar(BuildContext context) {
    Navigator.pushNamed(
      context,
      '/inscripcion',
      arguments: provider.obtenerGruposSeleccionados(),
    );
  }
}
