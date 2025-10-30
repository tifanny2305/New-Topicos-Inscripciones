import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/models/inscripcion/estado/estado_response.dart';
import 'package:inscripcion_topicos/models/inscripcion/inscripcion_request.dart';
import '../services/inscripcion_service.dart';

class InscripcionProvider with ChangeNotifier {
  final InscripcionService _service;

  InscripcionProvider(this._service);

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
  Future<void> crearInscripcion(InscripcionRequest request, String token) async {
    _cargando = true;
    _error = null;
    _intentosPolling = 0;
    notifyListeners();

    try {
      print('📝 Creando inscripción...');
      final response = await _service.crear(request, token);
      
      print('✅ Inscripción creada. Transaction ID: ${response.transactionId}');
      
      _transactionIdActual = response.transactionId;
      
      // Estado inicial: procesando
      _estadoActual = EstadoResponse(
        estado: 'procesando',
        datos: null,
      );

      _cargando = false;
      notifyListeners();

      // Iniciar polling después de notificar
      print('🔄 Iniciando polling...');
      _iniciarPolling(token);

    } catch (e) {
      print('❌ Error al crear inscripción: $e');
      _error = e.toString();
      _cargando = false;
      notifyListeners();
      rethrow;
    }
  }

  /// Consulta el estado actual
  Future<void> consultarEstado(String token) async {
    if (_transactionIdActual == null) {
      print('⚠️ No hay transaction ID para consultar');
      return;
    }

    try {
      _intentosPolling++;
      print('🔍 Consultando estado (intento $_intentosPolling/$_maxIntentos)...');
      
      final estado = await _service.consultarEstado(_transactionIdActual!, token);
      _estadoActual = estado;

      print('📊 Estado recibido: ${estado.estado}');
      
      // Detener si ya procesó o llegó al límite
      if (estado.esProcesado) {
        print('✅ Inscripción procesada exitosamente');
        detenerPolling();
      } else if (_intentosPolling >= _maxIntentos) {
        print('⏱️ Se alcanzó el límite de intentos');
        detenerPolling();
        _error = 'El servidor está tardando más de lo normal. '
                 'Por favor, verifica tu inscripción más tarde.';
      }

      notifyListeners();
    } catch (e) {
      print('❌ Error al consultar estado: $e');
      _error = e.toString();
      detenerPolling();
      notifyListeners();
    }
  }

  void _iniciarPolling(String token) {
    detenerPolling();
    
    // Primera consulta inmediata
    Future.delayed(const Duration(seconds: 2), () {
      if (_transactionIdActual != null) {
        consultarEstado(token);
      }
    });
    
    // Luego consultas periódicas
    _pollingTimer = Timer.periodic(_intervaloPolling, (_) {
      consultarEstado(token);
    });
  }

  void detenerPolling() {
    if (_pollingTimer != null) {
      print('🛑 Deteniendo polling');
      _pollingTimer?.cancel();
      _pollingTimer = null;
    }
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