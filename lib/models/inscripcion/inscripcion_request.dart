class InscripcionRequest {
  final int estudianteId;
  final int gestionId;
  final String fecha;
  final List<int> grupos;

  InscripcionRequest({
    required this.estudianteId,
    required this.gestionId,
    required this.fecha,
    required this.grupos,
  });

  Map<String, dynamic> toJson() {
    return {
      'estudiante_id': estudianteId,
      'gestion_id': gestionId,
      'fecha': fecha,
      'grupos': grupos,
    };
  }

  factory InscripcionRequest.fromJson(Map<String, dynamic> json) {
    return InscripcionRequest(
      estudianteId: json['estudiante_id'] as int,
      gestionId: json['gestion_id'] as int,
      fecha: json['fecha'] as String,
      grupos: (json['grupos'] as List).cast<int>(),
    );
  }
}