class Historial {
  final String materia;
  final double nota;
  final int grupoId;

  Historial({
    required this.materia,
    required this.nota,
    required this.grupoId,
  });

  factory Historial.fromJson(Map<String, dynamic> json) {
    final notaRaw = json['nota'];
    final notaDouble = notaRaw is double 
        ? notaRaw 
        : double.tryParse(notaRaw?.toString() ?? '0.0') ?? 0.0;

    return Historial(
      materia: json['materia'] as String? ?? 'Sin nombre',
      nota: notaDouble,
      grupoId: json['grupo_id'] as int? ?? 0,
    );
  }
}