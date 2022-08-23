import 'package:flutter/material.dart';
import 'package:kayu_bem/models/section.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8, right: 8),
      child: Text(
        section.nome!,
        textAlign: section.ordem! % 2 == 0
            ? TextAlign.end
            : TextAlign.start,
        style: const TextStyle(
          shadows: [
            Shadow(
                color: Colors.indigo,
                offset: Offset(0.0, 3.0),
                blurRadius: 3.0)
          ],
            color: Colors.white, fontWeight: FontWeight.w800, fontSize: 24),
      ),
    );
  }
}
