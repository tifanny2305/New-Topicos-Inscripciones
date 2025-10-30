import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/widgets/barra_superior.dart';
import '../widgets/barra_inferior.dart'; 

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BarraSuperior(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 80,
              color: Colors.blue.shade600,
            ),
            const SizedBox(height: 20),
            const Text(
              '¡Bienvenido a la Página de Inicio!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            
            Text(
              'Aquí encontrarás un resumen de tu actividad académica.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BarraInferior(indiceActual: 0),
    );
  }
}