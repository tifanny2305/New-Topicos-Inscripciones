import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/providers/login_provider.dart';
import '../models/materia.dart';
import '../models/grupo.dart';
import '../services/grupo_service.dart';

class MateriaConGrupos {
  final Materia materia;
  final List<Grupo> grupos;
  int? grupoSeleccionadoId;

  MateriaConGrupos({
    required this.materia,
    required this.grupos,
    this.grupoSeleccionadoId,
  });
}

class GrupoProvider with ChangeNotifier {
  final GrupoService _service;
  final LoginProvider _loginProvider;

  GrupoProvider(this._service, this._loginProvider);

  List<MateriaConGrupos> _materiasConGrupos = [];
  bool _estaCargando = false;
  String? _error;

  // Getters básicos
  List<MateriaConGrupos> get materiasConGrupos => _materiasConGrupos;
  bool get estaCargando => _estaCargando;
  String? get error => _error;

  // Getters calculados
  int get materiasSeleccionadas => 
      _materiasConGrupos.where((m) => m.grupoSeleccionadoId != null).length;

  int get progresoSeleccion {
    if (_materiasConGrupos.isEmpty) return 0;
    return ((materiasSeleccionadas / _materiasConGrupos.length) * 100).round();
  }

  bool get tieneAlMenosUnaSeleccionada => materiasSeleccionadas > 0;

  bool get todasTienenCupo {
    for (var mc in _materiasConGrupos) {
      if (mc.grupoSeleccionadoId != null) {
        final grupo = mc.grupos.firstWhere((g) => g.id == mc.grupoSeleccionadoId);
        if (grupo.cupo <= 0) return false;
      }
    }
    return true;
  }

  bool get puedesContinuar => tieneAlMenosUnaSeleccionada && todasTienenCupo;

  // Métodos
  Future<void> cargarGrupos(List<Materia> materias) async {
    _estaCargando = true;
    _error = null;
    _materiasConGrupos = [];
    notifyListeners();

    final token = _loginProvider.token;
    if (token == null || materias.isEmpty) {
      _error = 'Token no disponible o sin materias';
      _estaCargando = false;
      notifyListeners();
      return;
    }

    try {
      final futures = materias.map((materia) async {
        final grupos = await _service.obtenerGruposPorMateria(materia.id, token);
        return MateriaConGrupos(materia: materia, grupos: grupos);
      }).toList();

      _materiasConGrupos = await Future.wait(futures);
    } catch (e) {
      _error = 'Error al cargar grupos: ${e.toString()}';
      _materiasConGrupos = materias
          .map((m) => MateriaConGrupos(materia: m, grupos: []))
          .toList();
    } finally {
      _estaCargando = false;
      notifyListeners();
    }
  }

  void seleccionarGrupo(int materiaId, int grupoId) {
    final index = _materiasConGrupos.indexWhere((m) => m.materia.id == materiaId);
    if (index != -1) {
      if (_materiasConGrupos[index].grupoSeleccionadoId == grupoId) {
        _materiasConGrupos[index].grupoSeleccionadoId = null;
      } else {
        _materiasConGrupos[index].grupoSeleccionadoId = grupoId;
      }
      notifyListeners();
    }
  }

  List<Map<String, dynamic>> obtenerGruposSeleccionados() {
    return _materiasConGrupos
        .where((mc) => mc.grupoSeleccionadoId != null)
        .map((mc) {
      final grupo = mc.grupos.firstWhere((g) => g.id == mc.grupoSeleccionadoId);
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
            .map((h) => {
                  'dia': h.dia,
                  'horaInicio': h.horaInicio,
                  'horaFin': h.horaFin,
                })
            .toList(),
      };
    }).toList();
  }
}