import 'package:flutter/material.dart';
import 'package:kayu_bem/common/empty_card.dart';
import 'package:kayu_bem/common/login_card.dart';
import 'package:kayu_bem/common/price_card.dart';
import 'package:kayu_bem/helpers/scroll_listener.dart';
import 'package:kayu_bem/models/cart_manager.dart';
import 'package:provider/provider.dart';

import 'components/cart_tile.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('CARRINHO'), centerTitle: true),
        body: Consumer<CartManager>(builder: (_, cartManager, __) {
          if (cartManager.usuario == null) {
            return LoginCard();
          }
          if (cartManager.items.isEmpty) {
            return const EmptyCard(
                iconData: Icons.remove_shopping_cart,
                titulo: 'Nenhum produto no carrinho!');
          }
          return ListView(children: [
            Column(
                children: cartManager.items.map((p) => CartTile(p)).toList()),
            const SizedBox(height: 190)
          ]);
        }),
        bottomSheet: Consumer<CartManager>(
            builder: (_, cartManager, __) => cartManager.items.isNotEmpty
                ? SizedBox(
                    height: 190,
                    child: PriceCard(
                        'CONTINUAR PARA ENTREGA',
                        cartManager.carrinhoValido
                            ? () => Navigator.of(context).pushNamed('/address')
                            : null,
                        marginHorizontal: 8,
                        marginVertical: 0))
                : Container()));
  }
}
