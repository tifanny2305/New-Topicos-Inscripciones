import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inscripcion_topicos/models/inscripcion/estado/estado_response.dart';
import 'package:inscripcion_topicos/models/inscripcion/inscripcion_request.dart';
import 'package:inscripcion_topicos/models/inscripcion/inscripcion_response.dart';
import '../core/endpoint.dart';

class InscripcionService {
  
  /// POST /inscripciones/inscripciones - Crea la inscripción
  Future<InscripcionResponse> crear(
    InscripcionRequest request,
    String token,
  ) async {
    try {
      final url = Uri.parse(Endpoints.inscripcion);
      
      print('🔵 Enviando inscripción a: $url');
      print('🔵 Body: ${jsonEncode(request.toJson())}');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      print('🔵 Status Code: ${response.statusCode}');
      print('🔵 Response Body: ${response.body}');

      if (response.statusCode == 200 || 
          response.statusCode == 201 || 
          response.statusCode == 202) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return InscripcionResponse.fromJson(data);
      } else {
        throw Exception(
          'Error al crear inscripción: Código ${response.statusCode}. '
          'Mensaje: ${response.body}',
        );
      }
    } catch (e) {
      print('🔴 Error en crear(): $e');
      rethrow;
    }
  }

  /// GET /inscripciones/estado/{uuid} - Consulta el estado
  Future<EstadoResponse> consultarEstado(
    String transactionId,
    String token,
  ) async {
    try {
      final url = Uri.parse(Endpoints.estadoInscripcion(transactionId));
      
      print('🟢 Consultando estado: $url');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('🟢 Status Code: ${response.statusCode}');
      print('🟢 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return EstadoResponse.fromJson(data);
      } else {
        throw Exception(
          'Error al consultar estado: Código ${response.statusCode}. '
          'Mensaje: ${response.body}',
        );
      }
    } catch (e) {
      print('🔴 Error en consultarEstado(): $e');
      rethrow;
    }
  }
}