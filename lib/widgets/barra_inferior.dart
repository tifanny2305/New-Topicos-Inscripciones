import 'package:flutter/material.dart';

class BarraInferior extends StatelessWidget {
  final int indiceActual; 

  const BarraInferior({
    Key? key,
    required this.indiceActual,
  }) : super(key: key);

  void _navegar(BuildContext context, int indice) {
    if (indice == indiceActual) return;

    switch (indice) {
      case 0:
        Navigator.pushReplacementNamed(context, '/materias');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/historial');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: indiceActual,
      onTap: (indice) => _navegar(context, indice),
      selectedItemColor: Colors.blue.shade700,
      unselectedItemColor: Colors.grey.shade600,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Materias',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Historial',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}