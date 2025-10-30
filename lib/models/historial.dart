class Historial {
  final String materia;
  final double? nota;
  final int grupoId;

  Historial({
    required this.materia,
    required this.nota,
    required this.grupoId,
  });

  factory Historial.fromJson(Map<String, dynamic> json) {
    final notaRaw = json['nota'];
    double? notaDouble;

    if (notaRaw != null) {
      if (notaRaw is double) {
        notaDouble = notaRaw;
      } else {
        notaDouble = double.tryParse(notaRaw.toString()); 
      }
    }

    return Historial(
      materia: json['materia'] as String? ?? 'Sin nombre',
      nota: notaDouble,
      grupoId: json['grupo_id'] as int? ?? 0,
    );
  }
}