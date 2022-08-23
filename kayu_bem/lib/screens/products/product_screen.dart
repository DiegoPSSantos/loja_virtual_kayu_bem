import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/cart_manager.dart';
import 'package:kayu_bem/models/product.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kayu_bem/models/user_manager.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';

import 'components/size_widget.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen(this.produto);

  final Product produto;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    // value fornece um produto existente
    return ChangeNotifierProvider.value(
      value: produto,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Padding(padding: const EdgeInsets.only(right: 16), child: Text(produto.nome!, softWrap: true)),
        ),
        backgroundColor: Colors.white,
        body: ListView(
          padding: const EdgeInsets.only(top: 4),
          children: [
            CarouselSlider(
                items: produto.imagens!
                    .map((img) => ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: img.url!,
                      fit: BoxFit.cover,
                      cacheKey: img.hashCode.toString(),
                      cacheManager: CacheManager(Config(img.hashCode.toString(), stalePeriod: const Duration(minutes: 5))),
                      placeholder: (context, url) => const LoadingIndicator(
                          indicatorType: Indicator.ballScaleMultiple,
                          colors: [Color.fromARGB(255, 99, 111, 164), Color.fromARGB(255, 232, 203, 192)]),
                    )))
                    .toList(),
                options: CarouselOptions(
                    aspectRatio: 1, enableInfiniteScroll: false, enlargeCenterPage: true, viewportFraction: 0.98)),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text(
                    produto.nome!,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('A partir de', style: TextStyle(color: Colors.grey[600], fontSize: 14))),
                  Text(
                    'R\$ ${StringHelper.getValorMonetario(produto.encontrarMenorPreco().toString())}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 6),
                      child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          expandedAlignment: Alignment.topLeft,
                          textColor: Colors.black,
                          iconColor: Colors.black,
                          title: const Text(
                            'Descrição',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          children: [
                            Text(
                              produto.descricao!,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 16),
                            )
                          ])),
                  const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 6),
                      child: Text(
                        'Tamanhos',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      )),
                  Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: produto.tamanhos!.map((t) {
                        return SizeWidget(tamanho: t);
                      }).toList()),
                  const SizedBox(height: 20),
                  if (produto.estoqueDisponivel)
                    Consumer2<UserManager, Product>(builder: (_, userManager, produto, __) {
                      return SizedBox(
                          height: 44,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(onPrimary: Colors.white, primary: primaryColor),
                              onPressed: produto.existeTamanhoSelecionado
                                  ? () {
                                      if (userManager.isLoggedIn) {
                                        context.read<CartManager>().adicionarProdutoCarrinho(produto);
                                        showDialog(
                                            context: context,
                                            builder: (bc) => AlertDialog(
                                                  title: const Text('Produto adicionado ao carrinho'),
                                                  actions: [
                                                    ElevatedButton(
                                                        onPressed: () => Navigator.of(context)
                                                            .popUntil((route) => route.settings.name == '/'),
                                                        style: ElevatedButton.styleFrom(
                                                            onPrimary: Colors.white, primary: primaryColor),
                                                        child: const Text('OK',
                                                            style:
                                                                TextStyle(fontSize: 18, fontWeight: FontWeight.w500)))
                                                  ],
                                                ));
                                      } else {
                                        Navigator.of(context).pushNamed('/login');
                                      }
                                    }
                                  : null,
                              child: Text(userManager.isLoggedIn ? 'ADICIONAR AO CARRINHO' : 'ENTRE PARA COMPRAR',
                                  style: const TextStyle(fontSize: 16))));
                    })
                ])),
          ],
        ),
      ),
    );
  }
}
