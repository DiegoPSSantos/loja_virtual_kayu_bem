import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kayu_bem_gestor/helpers/string_helpers.dart';
import 'package:kayu_bem_gestor/models/cart_manager.dart';
import 'package:kayu_bem_gestor/models/product.dart';
import 'package:kayu_bem_gestor/models/user_manager.dart';
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
          actions: [
            IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => Navigator.of(context).pushReplacementNamed('/edit_product', arguments: produto))
          ],
        ),
        backgroundColor: Colors.white,
        body: ListView(
          padding: const EdgeInsets.only(top: 10),
          children: [
            CarouselSlider(
                items: produto.imagens!
                    .map((img) => Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(image: NetworkImage(img.url! as String), fit: BoxFit.fitHeight))))
                    .toList(),
                options: CarouselOptions(
                    aspectRatio: 1, enableInfiniteScroll: false, enlargeCenterPage: true, viewportFraction: 0.95)),
            Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Text(
                    produto.nome!,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(produto.menorPreco.isInfinite ? '' : 'A partir de', style: TextStyle(color: Colors.grey[600], fontSize: 14))),
                  Text(
                    produto.menorPreco.isInfinite
                        ? 'Produto indisponível'
                        : 'R\$ ${StringHelper.getValorMonetario(produto.menorPreco.toString())}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primaryColor),
                  ),
                  const Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 6),
                      child: Text(
                        'Descrição',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      )),
                  Text(
                    produto.descricao!,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontSize: 16),
                  ),
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
                                        Navigator.of(context).pushNamed('/cart');
                                      } else {
                                        Navigator.of(context).pushNamed('/login');
                                      }
                                    }
                                  : null,
                              child: const Text('SALVAR', style: TextStyle(fontSize: 16))));
                    })
                ])),
          ],
        ),
      ),
    );
  }
}
