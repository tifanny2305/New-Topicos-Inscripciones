import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/models/materia.dart';
import 'package:inscripcion_topicos/page/grupos/grupos_page.dart';
import 'package:inscripcion_topicos/page/historial/historial_page.dart';
import 'package:inscripcion_topicos/page/login/login_page.dart';
import 'package:inscripcion_topicos/page/materias/materias_page.dart';
import 'package:inscripcion_topicos/page/perfil/perfil_page.dart';
import 'package:inscripcion_topicos/providers/grupo_provider.dart';
import 'package:inscripcion_topicos/providers/historial_provider.dart';
import 'package:inscripcion_topicos/providers/login_provider.dart';
import 'package:inscripcion_topicos/providers/materia_provider.dart';
import 'package:inscripcion_topicos/providers/perfil_provider.dart';
import 'package:inscripcion_topicos/services/grupo_service.dart';
import 'package:inscripcion_topicos/services/historial_service.dart';
import 'package:inscripcion_topicos/services/login_service.dart';
import 'package:inscripcion_topicos/services/materia_service.dart';
import 'package:inscripcion_topicos/services/perfil_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatelessWidget {
  const MiAplicacion({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider(LoginService())),

        ChangeNotifierProvider(
          create: (_) => MateriaProvider(MateriaService()),
        ),

        ChangeNotifierProvider(create: (_) => PerfilProvider(PerfilService())),

        ChangeNotifierProvider(
          create: (_) =>
              GrupoProvider(GrupoService(), LoginProvider(LoginService())),
        ),

        ChangeNotifierProvider(create: (_) => HistorialProvider(HistorialService())),



        
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const LoginPage(),
          '/materias': (context) => const MateriasPage(),
          '/perfil': (context) => const PerfilPage(),
          '/grupos': (context) {
            final materias =
                ModalRoute.of(context)!.settings.arguments as List<Materia>;
            return GruposPage(materias: materias);
          },
          '/historial': (context) => const HistorialPage(),
        },
      ),
    );
  }
}
