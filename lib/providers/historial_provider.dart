import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/models/historial.dart';
import 'package:inscripcion_topicos/providers/login_provider.dart';
import 'package:provider/provider.dart';
import '../services/historial_service.dart';

class HistorialProvider with ChangeNotifier {
  final HistorialService _service;

  HistorialProvider(this._service);

  // --- ESTADO ---
  List<Historial> _historial = [];
  bool _estaCargando = false;
  String? _error;

  // --- GETTERS ---
  List<Historial> get historial => _historial;
  bool get estaCargando => _estaCargando;
  String? get error => _error;

  // Propiedad calculada
  double get promedioGeneral {
    final historialConNotaFinal = _historial
        .where((item) => item.nota != null)
        .toList();
    if (historialConNotaFinal.isEmpty) return 0.0;
    final sumatoriaNotas = historialConNotaFinal.fold(
      0.0,
      (sum, item) => sum + item.nota!,
    );
    return sumatoriaNotas / historialConNotaFinal.length;
  }

  /// Carga el historial académico del estudiante usando el ID y el token de autenticación
  Future<void> cargarHistorial(int estudianteId, String token) async {
    _establecerCarga(true);

    try {
      _historial = await _service.obtenerHistorial(estudianteId, token);

      _error = null;
    } catch (e) {
      _historial = [];
      _error = 'Error al cargar el historial académico: ${e.toString()}';
      print('Error al cargar el historial: $_error');
    }

    _establecerCarga(false);
  }

  List<Historial> get historialOrdenado {
    final listaOrdenada = List<Historial>.from(_historial);

    listaOrdenada.sort((a, b) {
      final aEstaEnCurso = a.nota == null;
      final bEstaEnCurso = b.nota == null;

      final prioridadA = aEstaEnCurso ? 1 : 0;
      final prioridadB = bEstaEnCurso ? 1 : 0;

      final resultadoComparacion = prioridadA.compareTo(prioridadB);

      if (resultadoComparacion != 0) {
        return resultadoComparacion;
      }
      return a.materia.compareTo(b.materia);
    });

    return listaOrdenada;
  }

  Future<void> reintentarCargaHistorias(BuildContext context) async {
    final loginProvider = Provider.of<LoginProvider>(context, listen: false);
    final historialProvider = Provider.of<HistorialProvider>(
      context,
      listen: false,
    );

    final estudianteId = loginProvider.estudianteId;
    final token = loginProvider.token;

    if (estudianteId != null && token != null) {
      await historialProvider.cargarHistorial(estudianteId, token);
    } else {
      print('Error de sesión: ID o Token nulo. Redirigiendo a Login.');
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  void _establecerCarga(bool estado) {
    _estaCargando = estado;
    notifyListeners();
  }
}
