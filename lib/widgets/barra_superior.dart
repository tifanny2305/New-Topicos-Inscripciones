import 'package:flutter/material.dart';
import 'package:inscripcion_topicos/providers/inscripcion_provider.dart';
import 'package:provider/provider.dart';

class BarraSuperior extends StatelessWidget implements PreferredSizeWidget {
  static const String tituloFijo = 'UAGRM - Sistema de Inscripciones';

  @override
  final Size preferredSize;

  const BarraSuperior({Key? key})
    : preferredSize = const Size.fromHeight(kToolbarHeight),
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        tituloFijo,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.blue.shade800,
      elevation: 4,
      automaticallyImplyLeading: false,
      actions: [
        // Icono de notificaciones con badge
        Consumer<InscripcionProvider>(
          builder: (context, provider, _) {
            final hayPendiente = provider.hayInscripcionPendiente;
            
            return Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    Navigator.pushNamed(context, '/notificaciones');
                  },
                ),
                if (hayPendiente)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
