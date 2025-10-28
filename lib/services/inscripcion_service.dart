import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inscripcion_topicos/models/inscripcion/estado_response.dart';
import 'package:inscripcion_topicos/models/inscripcion/inscripcion_request.dart';
import 'package:inscripcion_topicos/models/inscripcion/inscripcion_response.dart';
import '../core/endpoint.dart';

/// Servicio responsable SOLO de la comunicación con la API
class InscripcionService {
  
  /// POST /inscripciones - Crea la inscripción
  Future<InscripcionResponse> crear(
    InscripcionRequest request,
    String token,
  ) async {
    try {
      final url = Uri.parse(Endpoints.inscripcion());
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return InscripcionResponse.fromJson(data);
      } else {
        throw Exception(
          'Error al crear inscripción: Código ${response.statusCode}. '
          'Mensaje: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error al crear inscripción: ${e.toString()}');
    }
  }

  /*Future<EstadoResponse> consultarEstado(
    String transactionId,
    String token,
  ) async {
    try {
      final url = Uri.parse(Endpoints.inscripcion(transactionId));
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return EstadoResponse.fromJson(data);
      } else {
        throw Exception(
          'Error al consultar estado: Código ${response.statusCode}. '
          'Mensaje: ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Error al consultar estado: ${e.toString()}');
    }
  }*/
}