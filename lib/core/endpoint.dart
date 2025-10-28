class Endpoints {
  static const String baseUrl = 'http://localhost:3005/api';

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
    return '$baseUrl/grupos/grupo/$materiaId';
  }

  // Historial académico del estudiante
  static String historialEstudiante(int estudianteId) {
    return '$baseUrl/usuarios/grupos-estudiantes/estudiante/$estudianteId';
  }

}