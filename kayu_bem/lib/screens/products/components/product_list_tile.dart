import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/product.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ProductListTile extends StatelessWidget {
  const ProductListTile(this.produto);

  final Product produto;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/product', arguments: produto);
      },
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Container(
              height: 100,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: produto.imagens!.first.url!,
                        fit: BoxFit.cover,
                        cacheKey: produto.id,
                        cacheManager: CacheManager(Config(produto.id!, stalePeriod: const Duration(minutes: 5))),
                        placeholder: (context, url) => const LoadingIndicator(
                            indicatorType: Indicator.ballScaleMultiple,
                            colors: [Color.fromARGB(255, 99, 111, 164), Color.fromARGB(255, 232, 203, 192)]),
                      )),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 8, left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(produto.nome!,
                                      maxLines: 2,
                                      overflow: TextOverflow.clip,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
                              Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text('A partir de',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: 13, color: Colors.grey[600]))),
                              Text(
                                'R\$ ${StringHelper.getValorMonetario(produto.encontrarMenorPreco().toString())}',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w800, color: Theme.of(context).primaryColor),
                              )
                            ],
                          )))
                ],
              ))),
    );
  }
}
