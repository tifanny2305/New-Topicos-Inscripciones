import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/endpoint.dart';
import '../models/grupo.dart';

class GrupoService {

  Future<List<Grupo>> obtenerGruposPorMateria(int materiaId, String token) async {
    try {
      final url = Uri.parse(Endpoints.gruposPorMateria(materiaId));
   
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      
      if (response.statusCode == 200) {
        try {
          final grupos = (jsonDecode(response.body) as List)
              .map((json) => Grupo.fromJson(json))  // ← CORREGIDO
              .toList();
            
          return grupos;
          
        } catch (parseError) {
          
          throw Exception('Error al procesar datos de grupos: $parseError');
        }
      } else {
        
         throw Exception('Error al obtener grupos: Código ${response.statusCode}. Mensaje: ${response.body}');
      }
    } on http.ClientException catch (e) {
      throw Exception('Error de conexión al obtener grupos: $e');
    } catch (e) {
      throw Exception('Error al obtener grupos para la materia $materiaId: ${e.toString()}');
    }
  }
}