class EstadoResponse {
  final String estado; // "procesando" | "procesado"
  final int? inscripcionId; // ID si fue exitosa
  final String? mensaje;

  EstadoResponse({
    required this.estado,
    this.inscripcionId,
    this.mensaje,
  });

  factory EstadoResponse.fromJson(Map<String, dynamic> json) {
    final solicitud = json['Solicitud'] as Map<String, dynamic>;
    final datos = solicitud['datos'] as Map<String, dynamic>?;

    return EstadoResponse(
      estado: solicitud['estado'],
      inscripcionId: datos?['id'] as int?,
      mensaje: solicitud['message'] as String?,
    );
  }

  bool get esProcesando => estado == 'procesando';
  bool get esProcesado => estado == 'procesado';
  bool get esExitoso => esProcesado && inscripcionId != null;
}

