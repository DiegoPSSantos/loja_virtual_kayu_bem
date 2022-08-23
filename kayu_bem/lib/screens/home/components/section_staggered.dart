import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kayu_bem/models/section.dart';

import 'item_tile.dart';
import 'section_header.dart';

class SectionStaggered extends StatelessWidget {
  const SectionStaggered(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(section),
            StaggeredGridView.countBuilder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  // listview com menor tamanho possível
                  crossAxisCount: 4,
                  // total de unidades na horizontal
                  itemCount: section.items!.length,
                  itemBuilder: (_, index) => ItemTile(section.items![index], section.tipo!),
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                      2,
                      !index.isEven || index == section.items!.length - 1
                          ? 2
                          : 3),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                )
          ],
        ));
  }
}
