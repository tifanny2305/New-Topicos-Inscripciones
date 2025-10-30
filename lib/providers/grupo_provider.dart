import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../models/grupo.dart';
import '../services/grupo_service.dart';

class MateriaConGrupos {
  final Materia materia;
  final List<Grupo> grupos;
  int? grupoSeleccionadoId;

  MateriaConGrupos({required this.materia, required this.grupos, this.grupoSeleccionadoId});
}

class GrupoProvider with ChangeNotifier {
  final GrupoService _service;
  GrupoProvider(this._service);

  List<MateriaConGrupos> _materiasConGrupos = [];
  bool _estaCargando = false;
  String? _error;

  List<MateriaConGrupos> get materiasConGrupos => _materiasConGrupos;
  bool get estaCargando => _estaCargando;
  String? get error => _error;

  int get materiasSeleccionadas => 
      _materiasConGrupos.where((m) => m.grupoSeleccionadoId != null).length;

  int get progresoSeleccion => 
      _materiasConGrupos.isEmpty ? 0 : ((materiasSeleccionadas / _materiasConGrupos.length) * 100).round();

  bool get tieneAlMenosUnaSeleccionada => materiasSeleccionadas > 0;

  bool get todosLosSeleccionadosTienenCupo {
    for (var mc in _materiasConGrupos) {
      if (mc.grupoSeleccionadoId != null) {
        final grupo = mc.grupos.firstWhere((g) => g.id == mc.grupoSeleccionadoId);
        if (grupo.cupo <= 0) return false;
      }
    }
    return true;
  }

  bool get puedesContinuar => tieneAlMenosUnaSeleccionada && todosLosSeleccionadosTienenCupo;

  Future<void> cargarGrupos(List<Materia> materias, String token) async {
    _estaCargando = true;
    _error = null;
    _materiasConGrupos = [];
    notifyListeners();

    try {
      _materiasConGrupos = await Future.wait(
        materias.map((m) async => MateriaConGrupos(
          materia: m,
          grupos: await _service.obtenerGruposPorMateria(m.id, token),
        ))
      );
      _error = null;
    } catch (e) {
      _error = 'Error al cargar grupos: ${e.toString()}';
      _materiasConGrupos = materias.map((m) => MateriaConGrupos(materia: m, grupos: [])).toList();
    } finally {
      _estaCargando = false;
      notifyListeners();
    }
  }  

  void seleccionarGrupo(int materiaId, int grupoId) {
    final index = _materiasConGrupos.indexWhere(
      (m) => m.materia.id == materiaId,
    );
    if (index != -1) {
      _materiasConGrupos[index].grupoSeleccionadoId =
          _materiasConGrupos[index].grupoSeleccionadoId == grupoId
          ? null
          : grupoId;
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> obtenerGruposSeleccionados() {
    return _materiasConGrupos.where((mc) => mc.grupoSeleccionadoId != null).map(
      (mc) {
        final grupo = mc.grupos.firstWhere(
          (g) => g.id == mc.grupoSeleccionadoId,
        );
        return {
          'materiaId': mc.materia.id,
          'materiaNombre': mc.materia.nombre,
          'materiaSigla': mc.materia.sigla,
          'grupoId': grupo.id,
          'grupoSigla': grupo.sigla,
          'docenteId': grupo.docenteId,
          'docente': grupo.docente != null
              ? {'id': grupo.docente!.id, 'nombre': grupo.docente!.nombre}
              : null,
          'horarios': grupo.horarios
              .map(
                (h) => {
                  'dia': h.dia,
                  'horaInicio': h.horaInicio,
                  'horaFin': h.horaFin,
                },
              )
              .toList(),
        };
      },
    ).toList();
  }
}
