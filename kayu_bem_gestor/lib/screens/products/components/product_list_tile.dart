import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kayu_bem_gestor/helpers/string_helpers.dart';
import 'package:kayu_bem_gestor/models/product.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ProductListTile extends StatefulWidget {
  const ProductListTile(this.produto);

  final Product produto;

  @override
  State<ProductListTile> createState() => _ProductListTileState();
}

class _ProductListTileState extends State<ProductListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/edit_product', arguments: widget.produto);
      },
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          child: Container(
              height: 100,
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Stack(children: [
                    AspectRatio(
                        aspectRatio: 1,
                        child: CachedNetworkImage(
                          imageUrl: widget.produto.imagens!.first.url! as String,
                          fit: BoxFit.cover,
                          cacheKey: widget.produto.id,
                          cacheManager:
                              CacheManager(Config(widget.produto.id!, stalePeriod: const Duration(minutes: 5))),
                          placeholder: (context, url) => const LoadingIndicator(
                              indicatorType: Indicator.ballScaleMultiple,
                              colors: [Color.fromARGB(255, 99, 111, 164), Color.fromARGB(255, 232, 203, 192)]),
                        )),
                    Checkbox(
                        value: widget.produto.remove,
                        fillColor: MaterialStateProperty.all(Colors.redAccent),
                        onChanged: (valor) => setState(() => widget.produto.remove = valor!))
                  ]),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 8, left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(widget.produto.nome!,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800))),
                              Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(widget.produto.menorPreco.isInfinite ? '' : 'A partir de',
                                      textAlign: TextAlign.end,
                                      style: TextStyle(fontSize: 13, color: Colors.grey[600]))),
                              Text(
                                widget.produto.menorPreco.isInfinite
                                    ? 'Produto indisponível'
                                    : 'R\$ ${StringHelper.getValorMonetario(widget.produto.menorPreco.toString())}',
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
