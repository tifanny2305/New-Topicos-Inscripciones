import 'package:flutter/material.dart';

class EstadoProcesando extends StatelessWidget {
  final String transactionId;
  final int intentos;
  final int maxIntentos;

  const EstadoProcesando({
    Key? key,
    required this.transactionId,
    required this.intentos,
    required this.maxIntentos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(strokeWidth: 3),
            const SizedBox(height: 24),
            const Text(
              'Procesando inscripción...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Esto puede tardar unos segundos...',
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/home',
                  (route) => false,
                );
              },
              icon: const Icon(Icons.home),
              label: const Text('Volver al inicio'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}