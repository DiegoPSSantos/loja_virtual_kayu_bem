import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {required this.iconData,
      required this.color,
      required this.onTap,
      required this.tamanho});

  final IconData iconData;
  final Color color;
  final VoidCallback onTap;
  final double? tamanho;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Icon(iconData, color: color, size: tamanho),
            ),
          ),
        ),
      );
}
