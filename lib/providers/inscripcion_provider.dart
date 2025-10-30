import 'dart:async';
import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/models/inscripcion/estado/estado_response.dart';
import 'package:inscripcion_topicos/models/inscripcion/inscripcion_request.dart';
import '../services/inscripcion_service.dart';

class TransaccionInfo {
  EstadoResponse? estadoActual;
  final String transactionId;
  String? error;
  int intentosPolling;

  TransaccionInfo({
    required this.transactionId,
    this.estadoActual,
    this.error,
    this.intentosPolling = 0,
  });

  bool get esProcesando => estadoActual?.esProcesando == true && error == null;
  bool get esExitoso => estadoActual?.esExitoso == true && error == null;
}

class InscripcionProvider with ChangeNotifier {
  final InscripcionService _service;
  final List<TransaccionInfo> _transacciones = [];
  Timer? _pollingTimer;
  bool _cargando = false;

  static const int _maxIntentos = 10;
  static const Duration _intervaloPolling = Duration(seconds: 7);

  InscripcionProvider(this._service);

  // GETTERS
  List<TransaccionInfo> get transacciones => _transacciones;
  bool get cargando => _cargando;
  bool get hayInscripcionPendiente => _transacciones.any((t) => t.esProcesando);

  /// Crea una inscripción y retorna el transactionId
  Future<String> crearInscripcion(
    InscripcionRequest request,
    String token,
  ) async {
    _cargando = true;
    notifyListeners();

    try {
      final response = await _service.crear(request, token);

      final nuevaTransaccion = TransaccionInfo(
        transactionId: response.transactionId,
        estadoActual: EstadoResponse(estado: 'procesando', datos: null),
      );

      _transacciones.add(nuevaTransaccion);

      _cargando = false;
      notifyListeners();

      _iniciarPolling(token);

      // Retornar el transactionId
      return response.transactionId;
    } catch (e) {
      _cargando = false;
      notifyListeners();
      rethrow;
    }
  }

  void _iniciarPolling(String token) {
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(
      _intervaloPolling,
      (_) => _consultarTodas(token),
    );
    Future.delayed(const Duration(seconds: 2), () => _consultarTodas(token));
  }

  Future<void> _consultarTodas(String token) async {
    final pendientes = _transacciones.where((t) => t.esProcesando).toList();

    for (var t in pendientes) {
      if (t.intentosPolling >= _maxIntentos) {
        t.error = 'Tiempo de espera excedido';
        continue;
      }

      try {
        t.intentosPolling++;
        t.estadoActual = await _service.consultarEstado(t.transactionId, token);
      } catch (e) {
        t.error = e.toString();
      }
    }

    if (pendientes.isEmpty) _pollingTimer?.cancel();
    notifyListeners();
  }

  void limpiarCompletadas() {
    _transacciones.removeWhere((t) => !t.esProcesando);
    notifyListeners();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }
}
