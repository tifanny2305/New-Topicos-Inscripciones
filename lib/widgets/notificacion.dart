// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/inscripcion_provider.dart';

// class NotificacionesPage extends StatelessWidget {
//   const NotificacionesPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Estado de Inscripción',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         backgroundColor: Colors.blue.shade800,
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Consumer<InscripcionProvider>(
//         builder: (context, provider, _) {
//           // Si no hay inscripción activa
//           if (provider.estadoActual == null) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.notifications_none,
//                     size: 80,
//                     color: Colors.grey.shade300,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'No hay inscripciones en proceso',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           final estado = provider.estadoActual!;
//           final esExitoso = estado.esExitoso;
//           final esPendiente = estado.esProcesando;
//           final tieneError = provider.error != null;

//           // Determinar color y estado
//           Color colorEstado;
//           IconData iconoEstado;
//           String textoEstado;

//           if (tieneError) {
//             colorEstado = Colors.red;
//             iconoEstado = Icons.error;
//             textoEstado = 'Error';
//           } else if (esPendiente) {
//             colorEstado = Colors.orange;
//             iconoEstado = Icons.pending;
//             textoEstado = 'Procesando';
//           } else if (esExitoso) {
//             colorEstado = Colors.green;
//             iconoEstado = Icons.check_circle;
//             textoEstado = 'Completada';
//           } else {
//             colorEstado = Colors.red;
//             iconoEstado = Icons.error;
//             textoEstado = 'Fallida';
//           }

//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Icono grande
//                     Container(
//                       width: 80,
//                       height: 80,
//                       decoration: BoxDecoration(
//                         color: colorEstado.withOpacity(0.1),
//                         shape: BoxShape.circle,
//                       ),
//                       child: Icon(
//                         iconoEstado,
//                         color: colorEstado,
//                         size: 40,
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Estado
//                     Text(
//                       textoEstado,
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         color: colorEstado,
//                       ),
//                     ),
//                     const SizedBox(height: 8),

//                     // Mensaje
//                     if (tieneError)
//                       Text(
//                         provider.error!,
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade700,
//                         ),
//                         textAlign: TextAlign.center,
//                       )
//                     else if (esPendiente)
//                       Column(
//                         children: [
//                           const Text(
//                             'Tu inscripción está siendo procesada',
//                             style: TextStyle(fontSize: 14),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 16),
//                           LinearProgressIndicator(
//                             value: provider.intentosPolling / 10,
//                             backgroundColor: Colors.grey.shade200,
//                             color: Colors.orange,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Intento ${provider.intentosPolling} de 10',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                         ],
//                       )
//                     else if (esExitoso)
//                       Text(
//                         estado.datos?.message ?? '¡Inscripción completada exitosamente!',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade700,
//                         ),
//                         textAlign: TextAlign.center,
//                       )
//                     else
//                       Text(
//                         'La inscripción no se pudo completar',
//                         style: TextStyle(
//                           fontSize: 14,
//                           color: Colors.grey.shade700,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),

//                     const SizedBox(height: 24),

//                     // Botón de acción
//                     if (esExitoso || tieneError)
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             Navigator.pushNamedAndRemoveUntil(
//                               context,
//                               '/materias',
//                               (route) => false,
//                             );
//                           },
//                           icon: const Icon(Icons.arrow_back),
//                           label: const Text('Volver a Materias'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: colorEstado,
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                           ),
//                         ),
//                       )
//                     else if (esPendiente)
//                       SizedBox(
//                         width: double.infinity,
//                         child: OutlinedButton.icon(
//                           onPressed: () {
//                             Navigator.pushNamedAndRemoveUntil(
//                               context,
//                               '/materias',
//                               (route) => false,
//                             );
//                           },
//                           icon: const Icon(Icons.arrow_back),
//                           label: const Text('Volver a Materias'),
//                           style: OutlinedButton.styleFrom(
//                             foregroundColor: Colors.blue,
//                             side: BorderSide(color: Colors.blue.shade300),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }