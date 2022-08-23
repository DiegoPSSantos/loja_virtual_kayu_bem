import 'package:flutter/material.dart';
import 'package:kayu_bem/common/price_card.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/cart_manager.dart';
import 'package:kayu_bem/models/cart_product.dart';
import 'package:kayu_bem/models/checkout_manager.dart';
import 'package:kayu_bem/models/endereco.dart';
import 'package:kayu_bem/models/user_manager.dart';
import 'package:provider/provider.dart';

import 'components/address_card.dart';

class AddressScreen extends StatefulWidget {
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool retirada = false;
  String tipo_endereco = 'Entrega';
  Endereco? endereco;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
        create: (_) => CheckoutManager(),
        update: (_, cartManager, checkoutManager) => checkoutManager!..atualizarCarrinho(cartManager),
        lazy: false,
        child: Scaffold(
        appBar: AppBar(
          title: const Text('ENTREGA'),
          centerTitle: true,
        ),
        body: ListView(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.circular(5)),
                  child: CheckboxListTile(
                      checkColor: Theme.of(context).primaryColor,
                      activeColor: Colors.white,
                      title: const Text(
                        StringHelper.REALIZAR_RETIRADA,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0),
                      ),
                      value: retirada,
                      onChanged: (value) => setState(() {
                            retirada = value!;
                            tipo_endereco = retirada ? 'Retirada' : 'Entrega';
                            alterarEndereco();
                          }))),
              Consumer2<CartManager, CheckoutManager>(
                  builder: (_, cartManager, checkoutManager, __) => Column(children: [
                        AddressCard(tipo_endereco: tipo_endereco),
                        PriceCard(
                            'CONTINUAR PARA PAGAMENTO',
                            cartManager.enderecoValido && retirada || cartManager.enderecoValido && cartManager.possuiEntrega
                                ? () => Navigator.of(context).pushNamed('/checkout')
                                : null)
                      ]))
            ],
          ),
        ));
  }

  void alterarEndereco() {
    var cm = context.read<CartManager>();
    if (retirada) {
      cm.getEnderecoCepAberto(StringHelper.CEP_ENDERECO_LOJA);
      cm.zerarTaxaEntrega();
    } else {
      cm.getEnderecoCepAberto(cm.usuario!.endereco!.cep!);
    }
  }
}
