import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/models/inscripcion/estado_response.dart';
import 'package:inscripcion_topicos/models/inscripcion/inscripcion_request.dart';
import '../services/inscripcion_service.dart';

class InscripcionProvider with ChangeNotifier {
  final InscripcionService _service;
  final String _token;

  InscripcionProvider(this._service, this._token);

  // Estado
  EstadoResponse? _estadoActual;
  String? _transactionIdActual;
  bool _cargando = false;
  String? _error;
  Timer? _pollingTimer;
  int _intentosPolling = 0;

  // Configuración
  static const int _maxIntentos = 10;
  static const Duration _intervaloPolling = Duration(seconds: 7);

  // Getters
  EstadoResponse? get estadoActual => _estadoActual;
  String? get transactionId => _transactionIdActual;
  bool get cargando => _cargando;
  String? get error => _error;
  int get intentosPolling => _intentosPolling;

  /// Crea una nueva inscripción e inicia el polling
  Future<void> crearInscripcion(InscripcionRequest request) async {
    _cargando = true;
    _error = null;
    _intentosPolling = 0;
    notifyListeners();

    try {
      final response = await _service.crear(request, _token);
      
      _transactionIdActual = response.transactionId;
      _estadoActual = EstadoResponse(
        estado: 'procesando',
        mensaje: response.message,
      );

      _iniciarPolling();

      _cargando = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _cargando = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Consulta el estado actual
  /*Future<void> consultarEstado() async {
    if (_transactionIdActual == null) return;

    try {
      final estado = await _service.consultarEstado(_transactionIdActual!, _token);
      _estadoActual = estado;
      _intentosPolling++;

      // Detener si ya procesó o llegó al límite
      if (estado.esProcesado || _intentosPolling >= _maxIntentos) {
        detenerPolling();
        
        // Si llegó al límite sin procesar
        if (!estado.esProcesado && _intentosPolling >= _maxIntentos) {
          _error = 'El servidor está tardando más de lo normal. '
                   'Por favor, verifica tu inscripción más tarde.';
        }
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      detenerPolling();
      notifyListeners();
    }
  }*/

  void _iniciarPolling() {
    detenerPolling();
    //_pollingTimer = Timer.periodic(_intervaloPolling, (_) => consultarEstado());
  }

  void detenerPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  void limpiarEstado() {
    detenerPolling();
    _estadoActual = null;
    _transactionIdActual = null;
    _error = null;
    _cargando = false;
    _intentosPolling = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    detenerPolling();
    super.dispose();
  }
}