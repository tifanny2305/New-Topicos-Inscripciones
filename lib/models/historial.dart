class Historial {
  final int id;
  final double nota;
  final int creditos;
  final int estudianteId;
  final int grupoId;
  final String materiaNombre;
  final String materiaSigla;
  final String gestionNombre;

  Historial({
    required this.id,
    required this.nota,
    required this.creditos,
    required this.estudianteId,
    required this.grupoId,
    required this.materiaNombre,
    required this.materiaSigla,
    required this.gestionNombre,
  });

  /// Factory para crear una instancia desde un mapa JSON.
  factory Historial.fromJson(Map<String, dynamic> json) {
    final notaString = json['nota']?.toString() ?? '0.0';

    return Historial(
      id: json['id'] as int? ?? 0,
      nota: double.tryParse(notaString) ?? 0.0,
      creditos: json['creditos'] as int? ?? 0,
      estudianteId: json['estudiante_id'] as int? ?? 0,
      grupoId: json['grupo_id'] as int? ?? 0,
      materiaNombre: json['materiaNombre'] as String? ?? '',
      materiaSigla: json['materiaSigla'] as String? ?? '',
      gestionNombre: json['gestionNombre'] as String? ?? '',
    );
  }
}
