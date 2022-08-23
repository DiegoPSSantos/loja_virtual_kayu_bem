import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/cart_product.dart';
import 'package:loading_indicator/loading_indicator.dart';

class PedidoItemTile extends StatelessWidget {
  const PedidoItemTile(this.item);

  final CartProduct item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => item.produtoId.isEmpty
          ? showDialog(
              context: context,
              builder: (bc) => AlertDialog(
                    title: const Text('Esse produto não está mais disponível!'),
                    actions: [
                      ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                              onPrimary: Colors.white,
                              primary: Theme.of(context).primaryColor),
                          child: const Text('OK',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)))
                    ],
                  ))
          : Navigator.of(context)
              .pushNamed('/product', arguments: item.produto),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            SizedBox(
                height: 60,
                width: 60,
                child: CachedNetworkImage(
                  imageUrl: item.urlImagem,
                  fit: BoxFit.cover,
                  cacheKey: item.produtoId,
                  cacheManager: CacheManager(Config(item.produtoId,
                      stalePeriod: const Duration(minutes: 5))),
                  placeholder: (context, url) => const LoadingIndicator(
                      indicatorType: Indicator.ballScaleMultiple,
                      colors: [
                        Color.fromARGB(255, 99, 111, 164),
                        Color.fromARGB(255, 232, 203, 192)
                      ]),
                )),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.produto.nome!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  Text(
                    'Tamanho: ${item.tamanho}',
                    style: const TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    'R\$ ${StringHelper.getValorMonetario((item.precoFixo ?? item.precoUnitario).toString())}',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 4),
                child: Text(
                  '${item.quantidade}',
                  style: const TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}
