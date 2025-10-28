import 'dart:convert';
import 'package:inscripcion_topicos/core/endpoint.dart';
import 'package:http/http.dart' as http;
import '../models/materia.dart';

class MateriaService {

  Future<List<Materia>> obtenerMaterias(int estudianteId, String token) async {
    try {
      final url = Uri.parse(Endpoints.materiasPorEstudiante(estudianteId));
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        
        final materias = data
            .map((json) => Materia.fromJson(json))
            .toList();
        
        print('${materias.length} materias obtenidas');
        return materias;
      } else {
         throw Exception('Error al obtener materias: Código ${response.statusCode}. Mensaje: ${response.body}');
      }
          
    } catch (e) {
      throw Exception('Error al obtener materias: ${e.toString()}');
    }
  }
}