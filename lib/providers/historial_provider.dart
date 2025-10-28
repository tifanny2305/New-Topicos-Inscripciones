import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/models/historial.dart';
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
    if (_historial.isEmpty) return 0.0;
    
    final sumatoriaNotas = _historial.fold(
      0.0, 
      (sum, item) => sum + item.nota,
    );
    return sumatoriaNotas / _historial.length;
  }

  /// Carga el historial académico del estudiante usando el ID y el token de autenticación
  Future<void> cargarHistorial(int estudianteId, String token) async {
    _establecerCarga(true);

    try {
      _historial = await _service.obtenerHistorial(estudianteId, token); 
      
      // Ordenar el historial por gestión (ascendente)
      _historial.sort((a, b) => a.gestionNombre.compareTo(b.gestionNombre));
      
      _error = null;
    } catch (e) {
      _historial = [];
      _error = 'Error al cargar el historial académico: ${e.toString()}';
      print('Error al cargar el historial: $_error');
    }

    _establecerCarga(false);
  }

  void _establecerCarga(bool estado) {
    _estaCargando = estado;
    notifyListeners();
  }
}