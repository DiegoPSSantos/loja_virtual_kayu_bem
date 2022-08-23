import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:flutter_carousel_slider/carousel_slider_transforms.dart';
import 'package:kayu_bem/helpers/loading_helper.dart';
import 'package:kayu_bem/models/product_manager.dart';
import 'package:kayu_bem/models/section.dart';
import 'package:kayu_bem/models/section_item.dart';
import 'package:kayu_bem/screens/home/components/item_tile.dart';
import 'package:provider/provider.dart';

import 'section_header.dart';

class SectionCarroussel extends StatelessWidget {
  const SectionCarroussel(this.section);

  final Section section;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionHeader(section),
            SizedBox(
                height: 250,
                child: AspectRatio(
                    aspectRatio: 1,
                    child: CarouselSlider(
                      unlimitedMode: true,
                        slideIndicator: CircularSlideIndicator(
                          currentIndicatorColor: Colors.transparent,
                          indicatorBackgroundColor: Colors.transparent,
                          indicatorBorderColor: Colors.transparent,
                        ),
                        children: section.items!
                            .map((item) => ItemTile(
                                SectionItem(imagem: item.imagem, produto: item.produto, categoria: item.categoria),
                                section.tipo!))
                            .toList())))
          ],
        ));
  }
}
