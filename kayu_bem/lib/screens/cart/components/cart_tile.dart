import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kayu_bem/common/custom_icon_button.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/cart_product.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

class CartTile extends StatelessWidget {
  const CartTile(this.item);

  final CartProduct item;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider.value(
        value: item,
        child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
              child: Row(
                children: [
                  SizedBox(
                      width: 85,
                      height: 85,
                      child: CachedNetworkImage(
                        imageUrl: item.produto.imagens!.first.url!,
                        fit: BoxFit.cover,
                        cacheKey: item.produto.id ?? StringHelper.VAZIO,
                        cacheManager: CacheManager(
                            Config(item.produto.id ?? StringHelper.VAZIO, stalePeriod: const Duration(minutes: 5))),
                        placeholder: (context, url) => LoadingIndicator(
                            indicatorType: Indicator.ballScaleMultiple,
                            colors: const [Color.fromARGB(255, 99, 111, 164), Color.fromARGB(255, 232, 203, 192)]),
                      )),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                item.produto.nome!,
                                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text(
                                    'Tamanho: ${item.tamanho}',
                                    style: const TextStyle(fontWeight: FontWeight.w300),
                                  )),
                              Consumer<CartProduct>(
                                  builder: (_, cp, __) => Text(
                                        item.estoqueDisponivel
                                            ? 'R\$ ${StringHelper.getValorMonetario(item.precoUnitario.toString())}'
                                            : 'Sem estoque disponível',
                                        style: TextStyle(
                                            color: item.estoqueDisponivel ? Theme.of(context).primaryColor : Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ))
                            ],
                          ))),
                  Consumer<CartProduct>(
                    builder: (_, cp, __) => Column(
                      children: [
                        CustomIconButton(
                            iconData: Icons.add,
                            color: Theme.of(context).primaryColor,
                            onTap: cp.incrementar,
                            tamanho: IconTheme.of(context).size),
                        Text(
                          '${cp.quantidade}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        CustomIconButton(
                            iconData: Icons.remove,
                            color: cp.quantidade > 1 ? Theme.of(context).primaryColor : Colors.red,
                            onTap: cp.decrementar,
                            tamanho: IconTheme.of(context).size),
                      ],
                    ),
                  )
                ],
              ),
            )),
      );
}
