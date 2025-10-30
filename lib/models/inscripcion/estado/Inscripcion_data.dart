import 'package:inscripcion_topicos/models/inscripcion/estado/detalle.dart';

class InscripcionData {
  final int id;
  final String fecha;
  final int estudianteId;
  final int gestionId;
  final String createdAt;
  final String updatedAt;
  final List<DetalleInscripcion>? detalle;

  InscripcionData({
    required this.id,
    required this.fecha,
    required this.estudianteId,
    required this.gestionId,
    required this.createdAt,
    required this.updatedAt,
    this.detalle,
  });

  factory InscripcionData.fromJson(Map<String, dynamic> json) {
    return InscripcionData(
      id: json['id'] as int,
      fecha: json['fecha'] as String,
      estudianteId: json['estudiante_id'] as int,
      gestionId: json['gestion_id'] as int,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
      detalle: json['detalle'] != null
          ? (json['detalle'] as List)
              .map((e) => DetalleInscripcion.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha': fecha,
      'estudiante_id': estudianteId,
      'gestion_id': gestionId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      if (detalle != null) 'detalle': detalle!.map((e) => e.toJson()).toList(),
    };
  }
}