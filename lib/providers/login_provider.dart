import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/services/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  // Estado de autenticación
  String? _registro;
  String? _token;
  int? _estudianteId;
  bool _estaAutenticado = false;

  // Servicio de login
  final LoginService _loginService;

  // Constructor - recibe el servicio por inyección de dependencias
  LoginProvider(this._loginService);

  // Getters para acceder al estado
  String? get registro => _registro;
  String? get token => _token;
  int? get estudianteId => _estudianteId;
  bool get estaAutenticado => _estaAutenticado;

  /// Retorna true si el login fue exitoso, false en caso contrario
  Future<bool> iniciarSesion(String registro, String codigo) async {
    try {
      //Llamar al servicio para autenticar
      final resultado = await _loginService.iniciarSesion(registro, codigo);

      //Actualizar el estado con los datos obtenidos
      _registro = resultado['registro'];
      _token = resultado['token'];
      _estudianteId = resultado['estudianteId'];
      _estaAutenticado = true;

      // Guardar datos en persistencia local
      await _guardarDatosLocales();

      //Notificar a los listeners
      notifyListeners();

      return true;
    } catch (e) {
      print('Error en LoginProvider.iniciarSesion: ${e.toString()}');
      _estaAutenticado = false;
      return false;
    }
  }

  Future<void> _guardarDatosLocales() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tokenAuth', _token!);
    await prefs.setString('registroUsuario', _registro!);
    await prefs.setInt('idEstudiante', _estudianteId!);
  }

  /// Carga el token guardado al iniciar la aplicación
  Future<void> cargarTokenGuardado() async {
    final prefs = await SharedPreferences.getInstance();
    final tokenGuardado = prefs.getString('tokenAuth');

    if (tokenGuardado != null && tokenGuardado.isNotEmpty) {
      _token = tokenGuardado;
      _registro = prefs.getString('registroUsuario');
      _estudianteId = prefs.getInt('idEstudiante');
      _estaAutenticado = true;
      notifyListeners();
    }
  }

  /// Cierra la sesión del usuario
  Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();

    // Limpiar datos guardados
    await prefs.remove('tokenAuth');
    await prefs.remove('registroUsuario');
    await prefs.remove('idEstudiante');

    // Limpiar estado
    _registro = null;
    _token = null;
    _estudianteId = null;
    _estaAutenticado = false;

    notifyListeners();
  }
}
