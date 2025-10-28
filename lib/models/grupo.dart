class Grupo {
  final int id;
  final String sigla;
  final int cupo;
  final int materiaId;
  final int docenteId;
  final int gestionId;
  final Docente? docente;
  final List<Horario> horarios;

  Grupo({
    required this.id,
    required this.sigla,
    required this.cupo,
    required this.materiaId,
    required this.docenteId,
    required this.gestionId,
    this.docente,
    this.horarios = const [],
  });

  factory Grupo.fromJson(Map<String, dynamic> json) {
    // Maneja materia_id directamente del JSON
    int materiaIdValue;
    if (json['materia_id'] != null) {
      materiaIdValue = json['materia_id'] as int;
    } else if (json['materia'] != null && json['materia']['id'] != null) {
      materiaIdValue = json['materia']['id'] as int;
    } else {
      throw Exception('No se encontró materia_id en el JSON');
    }

    return Grupo(
      id: json['id'] as int,
      sigla: json['sigla'] as String,
      cupo: json['cupo'] as int,
      materiaId: materiaIdValue,
      docenteId: json['docente_id'] as int,
      gestionId: json['gestion_id'] as int,
      docente: json['docente'] != null 
          ? Docente.fromJson(json['docente']) 
          : null,
      horarios: json['horarios'] != null && json['horarios'] is List
          ? (json['horarios'] as List)
              .where((h) => h != null) // Filtra nulls
              .map((h) => Horario.fromJson(h as Map<String, dynamic>))
              .toList()
          : [],
    );
  }
}

class Docente {
  final int id;
  final String nombre;
  final String registro;

  Docente({required this.id, required this.nombre, required this.registro});

  factory Docente.fromJson(Map<String, dynamic> json) {
    return Docente(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      registro: json['registro'] as String,
    );
  }
}

class Horario {
  final int id;
  final String dia;
  final String horaInicio;
  final String horaFin;

  Horario({
    required this.id,
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
  });

  factory Horario.fromJson(Map<String, dynamic> json) {
    // Extrae valores manejando diferentes formatos de nombres
    String diaValue = '';
    if (json['dia'] != null) {
      diaValue = json['dia'].toString();
    } else if (json['day'] != null) {
      diaValue = json['day'].toString();
    }

    String horaInicioValue = '';
    if (json['horaInicio'] != null) {
      horaInicioValue = json['horaInicio'].toString();
    } else if (json['hora_inicio'] != null) {
      horaInicioValue = json['hora_inicio'].toString();
    } else if (json['start_time'] != null) {
      horaInicioValue = json['start_time'].toString();
    }

    String horaFinValue = '';
    if (json['horaFin'] != null) {
      horaFinValue = json['horaFin'].toString();
    } else if (json['hora_fin'] != null) {
      horaFinValue = json['hora_fin'].toString();
    } else if (json['end_time'] != null) {
      horaFinValue = json['end_time'].toString();
    }

    return Horario(
      id: json['id'] as int,
      dia: diaValue,
      horaInicio: horaInicioValue,
      horaFin: horaFinValue,
    );
  }
}