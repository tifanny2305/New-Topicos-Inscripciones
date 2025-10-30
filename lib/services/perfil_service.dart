import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/endpoint.dart';
import '../models/estudiante.dart';

class PerfilService {
  Future<Estudiante> obtenerPerfil(int estudianteId, String token) async {
    try {
      final url = Uri.parse(Endpoints.perfilEstudiante(estudianteId));
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', 
        },
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Estudiante.fromJson(data);
      } else {
         throw Exception('Error ${response.statusCode}: No se pudo obtener el perfil. Mensaje: ${response.body}');
      }
          
    } catch (e) {
      print('Error en PerfilService.obtenerPerfil: ${e.toString()}');
      throw Exception('Error de conexión o datos al obtener el perfil: ${e.toString()}');
    }
  }
}