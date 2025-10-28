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
        // Deserialización
        final List<dynamic> data = jsonDecode(response.body);
        
        final grupos = data
            .map((json) => Grupo.fromJson(json))
            .toList();

        print('${grupos.length} grupos obtenidos para materia $materiaId');
        return grupos;
      } else {
         throw Exception('Error al obtener grupos: Código ${response.statusCode}. Mensaje: ${response.body}');
      }
    } catch (e) {
      print('Error en GrupoService.obtenerGruposPorMateria: $e');
      throw Exception('Error al obtener grupos para la materia $materiaId: ${e.toString()}');
    }
  }
}
