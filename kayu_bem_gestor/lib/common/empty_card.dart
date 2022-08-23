import 'package:flutter/material.dart';

class EmptyCard extends StatelessWidget {

  const EmptyCard({required this.titulo, required this.iconData});

  final String titulo;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              iconData,
              size: 80,
              color: Colors.white
            ),
            const SizedBox(height: 16),
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
              textAlign: TextAlign.center,
            )
          ],
        )
    );
  }
}
