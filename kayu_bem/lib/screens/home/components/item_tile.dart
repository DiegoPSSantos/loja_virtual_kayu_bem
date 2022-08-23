import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kayu_bem/models/product_manager.dart';
import 'package:kayu_bem/models/section_item.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ItemTile extends StatelessWidget {
  const ItemTile(this.sectionItem, this.tipo);

  final SectionItem sectionItem;
  final String tipo;

  @override
  Widget build(BuildContext context) {
    double radiusBorder = 0;
    switch (tipo) {
      case 'List':
        radiusBorder = 10;
        break;
      case 'SquadList':
        radiusBorder = 80;
        break;
    }
    return GestureDetector(
        onTap: () async {
          if (sectionItem.produto != null) {
            final produto = await context
                .read<ProductManager>()
                .encontrarProdutoPorID(sectionItem.produto!, sectionItem.categoria!);
            if (produto != null) {
              Navigator.of(context).pushNamed('/product', arguments: produto);
            }
          }
        },
        child: AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(radiusBorder),
                child: CachedNetworkImage(
                  imageUrl: sectionItem.imagem!,
                  fit: BoxFit.cover,
                  cacheKey: sectionItem.produto,
                  cacheManager: CacheManager(Config(sectionItem.produto!, stalePeriod: const Duration(minutes: 5))),
                  placeholder: (context, url) => const LoadingIndicator(
                      indicatorType: Indicator.ballScaleMultiple,
                      colors: [Color.fromARGB(255, 99, 111, 164), Color.fromARGB(255, 232, 203, 192)]),
                ))));
  }
}
