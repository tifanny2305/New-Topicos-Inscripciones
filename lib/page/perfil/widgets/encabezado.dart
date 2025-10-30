import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/models/estudiante.dart';

class Encabezado extends StatelessWidget {
  final Estudiante perfil;
  final VoidCallback? onLogout;

  const Encabezado({
    Key? key,
    required this.perfil,
    this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Colors.blue.shade600),
          ),
          const SizedBox(height: 12),
          Text(
            perfil.nombre,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            'Registro: ${perfil.registro}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.blue.shade100,
            ),
          ),
          
          if (onLogout != null) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('Cerrar Sesión'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white70),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}