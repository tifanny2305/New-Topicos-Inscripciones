import 'package:flutter/material.dart';

class BarraSuperior extends StatelessWidget
  implements PreferredSizeWidget {
  
  static const String tituloFijo = 'UAGRM - Sistema de Inscripciones';

  @override
  final Size preferredSize; 

  const BarraSuperior({
    Key? key,
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        tituloFijo,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      backgroundColor: Colors.blue.shade800, 
      elevation: 4,
      actions: [

        const SizedBox(width: 8),
      ],
    );
  }
}


