import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/providers/login_provider.dart';
import 'package:inscripcion_topicos/services/materia_service.dart';
import 'package:provider/provider.dart';
import '../models/materia.dart';

class MateriaProvider with ChangeNotifier {
  final MateriaService _servicioMateria;
  MateriaProvider(this._servicioMateria);

  // Estado interno
  List<Materia> _listaMaterias = [];
  List<Materia> _materiasSeleccionadas = [];
  bool _estaCargando = false;
  String? _error;

  // Filtros activos
  String _terminoBusqueda = '';
  String _nivelSeleccionado = 'all';
  String _tipoSeleccionado = 'all';

  // Getters públicos (lectura)
  List<Materia> get materias => _listaMaterias;
  List<Materia> get materiasSeleccionadas => _materiasSeleccionadas;
  bool get estaCargando => _estaCargando;
  String? get error => _error;
  String get terminoBusqueda => _terminoBusqueda;
  String get nivelSeleccionado => _nivelSeleccionado;
  String get tipoSeleccionado => _tipoSeleccionado;

  /// Retorna las materias filtradas por búsqueda, nivel y tipo.
  List<Materia> get materiasFiltradas {
    return _listaMaterias.where((materia) {
      final coincideNivel =
          _nivelSeleccionado == 'all' ||
          materia.nivel.nombre == _nivelSeleccionado;

      final coincideTipo =
          _tipoSeleccionado == 'all' ||
          materia.tipo.nombre == _tipoSeleccionado;

      final coincideBusqueda =
          _terminoBusqueda.isEmpty ||
          materia.nombre.toLowerCase().contains(
            _terminoBusqueda.toLowerCase(),
          ) ||
          materia.sigla.toLowerCase().contains(_terminoBusqueda.toLowerCase());

      return coincideNivel && coincideTipo && coincideBusqueda;
    }).toList();
  }

  List<String> get nivelesDisponibles =>
      _listaMaterias.map((m) => m.nivel.nombre).toSet().toList()..sort();

  List<String> get tiposDisponibles =>
      _listaMaterias.map((m) => m.tipo.nombre).toSet().toList();

  // Métodos públicos
  Future<void> cargarMaterias(int estudianteId, String token) async {
    _establecerCarga(true);

    try {
      _materiasSeleccionadas.clear();

      final listado = await _servicioMateria.obtenerMaterias(
        estudianteId,
        token,
      );
      _listaMaterias = listado;
      _error = null;
    } catch (e) {
      _error = 'Error al cargar materias: ${e.toString()}';
      print('$_error');
    }

    _establecerCarga(false);
  }

  void alternarSeleccionMateria(Materia materia) {
    final index = _listaMaterias.indexWhere((m) => m.id == materia.id);
    if (index == -1) return;

    _listaMaterias[index].selected = !_listaMaterias[index].selected;

    if (_listaMaterias[index].selected) {
      _materiasSeleccionadas.add(_listaMaterias[index]);
    } else {
      _materiasSeleccionadas.removeWhere(
        (m) => m.id == _listaMaterias[index].id,
      );
    }

    notifyListeners();
  }

   // vista de error
  Future<void> reintentarCargaMaterias(BuildContext context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final materiaProvider = Provider.of<MateriaProvider>(
      context,
      listen: false,
    );

    final estudianteId = loginProvider.estudianteId;
    final token = loginProvider.token;

    if (estudianteId != null && token != null) {
      await materiaProvider.cargarMaterias(estudianteId, token);
    } else {
      print('Error de sesión: ID o Token nulo. Redirigiendo a Login.');
      Navigator.of(context).pushReplacementNamed('/');
    }
  }


  /// Aplica búsqueda por nombre o sigla.
  void aplicarTerminoBusqueda(String termino) {
    _terminoBusqueda = termino.trim();
    notifyListeners();
  }

  /// Aplica filtro por nivel.
  void aplicarFiltroNivel(String nivel) {
    _nivelSeleccionado = nivel;
    notifyListeners();
  }

  /// Aplica filtro por tipo.
  void aplicarFiltroTipo(String tipo) {
    _tipoSeleccionado = tipo;
    notifyListeners();
  }

  /// Limpia todas las selecciones actuales.
  void limpiarSeleccion() {
    for (var materia in _listaMaterias) {
      materia.selected = false;
    }
    _materiasSeleccionadas.clear();
    notifyListeners();
  }

  // Métodos privados (internos)
  /// Cambia el estado de carga y notifica.
  void _establecerCarga(bool valor) {
    _estaCargando = valor;
    notifyListeners();
  }
}
