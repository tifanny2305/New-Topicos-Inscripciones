import 'package:flutter/material.dart';
import '../models/estudiante.dart';
import '../services/perfil_service.dart';

class PerfilProvider with ChangeNotifier {
  final PerfilService _perfilService;

  PerfilProvider(this._perfilService);

  // --- ESTADO ---
  Estudiante? _perfil;
  bool _estaCargando = false;
  String? _error;

  // --- GETTERS ---
  Estudiante? get perfil => _perfil;
  bool get estaCargando => _estaCargando;
  String? get error => _error;

  /// Carga el perfil del estudiante usando el ID y el token de autenticación.
  Future<void> cargarPerfil(int estudianteId, String token) async {
    _establecerCarga(true);

    try {
      final data = await _perfilService.obtenerPerfil(estudianteId, token);
      _perfil = data;
      _error = null;
    } catch (e) {
      _error = 'Fallo al cargar el perfil: ${e.toString()}';
      print('Error al cargar el perfil: $_error');
    }

    _establecerCarga(false);
  }
  
  void _establecerCarga(bool estado) {
    _estaCargando = estado;
    notifyListeners();
  }
}