import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/common/price_card.dart';
import 'package:kayu_bem_gestor/models/cart_manager.dart';
import 'package:provider/provider.dart';

import 'components/address_card.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ENTREGA'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AddressCard(),
          Consumer<CartManager>(
              builder: (_, cartManager, __) => PriceCard(
                  'CONTINUAR PARA PAGAMENTO',
                  cartManager.enderecoValido
                      ? () => Navigator.of(context).pushNamed('/checkout')
                      : null))
        ],
      ),
    );
  }
}
