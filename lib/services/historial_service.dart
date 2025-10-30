import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inscripcion_topicos/models/historial.dart';
import '../core/endpoint.dart';

class HistorialService {

  Future<List<Historial>> obtenerHistorial(int estudianteId, String token) async {
    try {
      final endpoint = Endpoints.historialEstudiante(estudianteId);
      final url = Uri.parse(endpoint);
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final historial = (jsonDecode(response.body) as List)
            .map((json) => Historial.fromJson(json))
            .toList();
        
        print('${historial.length} registros de historial obtenidos');
        return historial;
      } else {
         throw Exception('Error al obtener historial: Código ${response.statusCode}. Mensaje: ${response.body}');
      }
          
    } catch (e) {
      print('Error en HistorialService.obtenerHistorial: ${e.toString()}');
      throw Exception('Error al obtener historial: ${e.toString()}');
    }
  }
}