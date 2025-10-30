import 'package:inscripcion_topicos/models/inscripcion/estado/Inscripcion_data.dart';

class EstadoResponse {

  final String estado;
  final DatosEstado? datos;

  EstadoResponse({
    required this.estado,
    this.datos,
  });

  factory EstadoResponse.fromJson(Map<String, dynamic> json) {
    // La respuesta viene con "Solicitud" como key principal
    final solicitud = json['Solicitud'] as Map<String, dynamic>?;
    
    if (solicitud == null) {
      throw Exception('Respuesta de estado inválida: falta el objeto Solicitud');
    }

    return EstadoResponse(
      estado: solicitud['estado'] as String,
      datos: solicitud['datos'] != null
          ? DatosEstado.fromJson(solicitud['datos'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Solicitud': {
        'estado': estado,
        if (datos != null) 'datos': datos!.toJson(),
      }
    };
  }

  bool get esProcesando => estado.toLowerCase() == 'procesando';
  bool get esProcesado => estado.toLowerCase() == 'procesado';
  bool get esExitoso => esProcesado && datos != null && datos!.success;
  
  int? get inscripcionId => datos?.data?.id;
}

class DatosEstado {
  final bool success;
  final String message;
  final InscripcionData? data;

  DatosEstado({
    required this.success,
    required this.message,
    this.data,
  });

  factory DatosEstado.fromJson(Map<String, dynamic> json) {
    return DatosEstado(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null
          ? InscripcionData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data!.toJson(),
    };
  }
}