import 'package:flutter/material.dart';
import 'package:kayu_bem/models/section.dart';
import 'package:kayu_bem/models/section_item.dart';
import 'package:kayu_bem/screens/home/components/item_tile.dart';

import 'section_header.dart';

class SectionList extends StatelessWidget {
  const SectionList(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    List<SectionItem> items =
        section.nome!.compareTo('Produtos em Alta') == 0 ? section.items!.reversed.toList() : section.items!;
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(section),
            SizedBox(
                height: 150,
                child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) => ItemTile(items[index], section.tipo!),
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemCount: items.length))
          ],
        ));
  }
}
