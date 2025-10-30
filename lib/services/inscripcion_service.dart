import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inscripcion_topicos/models/inscripcion/estado/estado_response.dart';
import 'package:inscripcion_topicos/models/inscripcion/inscripcion_request.dart';
import 'package:inscripcion_topicos/models/inscripcion/inscripcion_response.dart';
import '../core/endpoint.dart';

class InscripcionService {
  
  Future<InscripcionResponse> crear(
    InscripcionRequest request,
    String token,
  ) async {
    try {
      final url = Uri.parse(Endpoints.inscripcion);    
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

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
      rethrow;
    }
  }

  Future<EstadoResponse> consultarEstado(
    String transactionId,
    String token,
  ) async {
    try {
      final url = Uri.parse(Endpoints.estadoInscripcion(transactionId));     
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

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
      rethrow;
    }
  }
}