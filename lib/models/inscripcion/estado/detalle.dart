class DetalleInscripcion {
  final int id;
  final int inscripcionId;
  final int grupoId;
  final String createdAt;
  final String updatedAt;

  DetalleInscripcion({
    required this.id,
    required this.inscripcionId,
    required this.grupoId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DetalleInscripcion.fromJson(Map<String, dynamic> json) {
    return DetalleInscripcion(
      id: json['id'] as int,
      inscripcionId: json['inscripcion_id'] as int,
      grupoId: json['grupo_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'inscripcion_id': inscripcionId,
      'grupo_id': grupoId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}