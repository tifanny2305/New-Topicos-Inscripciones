import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inscripcion_topicos/core/endpoint.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginService {
   Future<Map<String, dynamic>> iniciarSesion(String registro, String codigo) async {

    try {
      final respuesta = await http.post(
        Uri.parse(Endpoints.iniciarSesion),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'registro': registro,
          'codigo': codigo,
        }),
      );

      if (respuesta.statusCode == 200 || respuesta.statusCode == 201) {
        final datos = jsonDecode(respuesta.body);
        
        final token = datos['token'];
        final estudianteRegistro = datos['registro'];
        
        final Map<String, dynamic> payload = JwtDecoder.decode(token);
        final int estudianteId = payload['id'];

        return {
          'token': token,
          'registro': estudianteRegistro,
          'estudianteId': estudianteId,
        };
      } else {
        throw Exception('Error en autenticación: ${respuesta.statusCode}');
      }
    } catch (e) {
      print('Error en LoginService.iniciarSesion: $e');
      throw Exception('No se pudo conectar con el servidor: $e');
    }
  }
}