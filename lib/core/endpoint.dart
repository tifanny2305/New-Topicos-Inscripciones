class Endpoints {
  static const String baseUrl = 'https://6930408a9838.ngrok-free.app/api';
  //static const String baseUrl = 'http://localhost:3005/api';

  //loguin
  static const String iniciarSesion = '$baseUrl/usuarios/auth/login';
  
  //maeria filtrada por estudiante (las que son disponibles)
  static String materiasPorEstudiante(int estudianteId) {
    return '$baseUrl/usuarios/estudiantes/$estudianteId/materias-disponibles';
  }

  //perfil del estudiante
  static String perfilEstudiante(int estudianteId) {
    return '$baseUrl/usuarios/estudiantes/$estudianteId';
  }

  //grupos por materia
  static String gruposPorMateria(int materiaId) {
    return '$baseUrl/inscripciones/grupos/materia/$materiaId';
  }

  // Historial académico del estudiante
  static String historialEstudiante(int estudianteId) {
    return '$baseUrl/inscripciones/grupos/historial/$estudianteId';
  }

  static String inscripcion() {
    return '$baseUrl/inscripciones/inscripciones';
  }

  

}