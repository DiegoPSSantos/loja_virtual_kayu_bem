import 'package:flutter/material.dart';
import 'package:kayu_bem/common/price_card.dart';
import 'package:kayu_bem/helpers/list_tipo_pagamento.dart';
import 'package:kayu_bem/helpers/loading_helper.dart';
import 'package:kayu_bem/helpers/radio_widget.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/cart_manager.dart';
import 'package:kayu_bem/models/cart_product.dart';
import 'package:kayu_bem/models/checkout_manager.dart';
import 'package:kayu_bem/models/credit_card.dart';
import 'package:kayu_bem/screens/checkout/components/pix_widget.dart';
import 'package:provider/provider.dart';

import 'components/cpf_field.dart';
import 'components/credit_card_widget.dart';
import 'components/mercadopago_widget.dart';

class CheckoutScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();
  final CreditCard creditCard = CreditCard();

  @override
  Widget build(BuildContext context) {
    int tipoPagamgento = 0;

    return ChangeNotifierProxyProvider<CartManager, CheckoutManager>(
        create: (_) => CheckoutManager(),
        update: (_, cartManager, checkoutManager) => checkoutManager!..atualizarCarrinho(cartManager),
        lazy: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('PAGAMENTO'),
            centerTitle: true,
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Stack(children: [
              Form(
                  key: formKey,
                  child: Container(
                    margin: const EdgeInsets.only(top: 80),
                    child: Consumer<CheckoutManager>(
                        builder: (_, checkoutManager, __) => ListView(
                              children: [
                                // if (checkoutManager.tipoPagamento == 0) CreditCardWidget(creditCard),
                                if (checkoutManager.tipoPagamento == 1) PixWidget(),
                                CPFField(),
                                PriceCard(
                                    checkoutManager.tipoPagamento == 1
                                        ? 'FINALIZAR PEDIDO'
                                        : 'FORNECER DADOS DO CARTÃO', () {
                                  if (checkoutManager.tipoPagamento == 1) {
                                    checkoutManager.checkoutPIX(onEstoqueFalha: (e) {
                                      Navigator.of(context).popUntil((route) => route.settings.name == '/cart');
                                    }, onSuccess: (pedido) {
                                      Navigator.of(context).popUntil((route) => route.settings.name == '/');
                                      Navigator.of(context).pushNamed('/confirmation', arguments: pedido);
                                    }, onPagamentoFalha: (error) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(error.toUpperCase() as String,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                          backgroundColor: Colors.red));
                                    });
                                  } else if (checkoutManager.tipoPagamento == 0) {
                                    List<CartProduct> produtos = context.read<CartManager>().items;
                                    // if (formKey.currentState!.validate()) {
                                    formKey.currentState!.save();
                                    checkoutManager.checkoutMercadoPagoCC(
                                        // creditCard: creditCard,
                                        produtos: produtos,
                                        onEstoqueFalha: (e) {
                                          Navigator.of(context).popUntil((route) => route.settings.name == '/cart');
                                        },
                                        onSuccess: (pedido) {
                                          Navigator.of(context).popUntil((route) => route.settings.name == '/');
                                          Navigator.of(context).pushNamed('/confirmation', arguments: pedido);
                                        },
                                        onPagamentoFalha: (error) {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text(error.toUpperCase() as String,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              backgroundColor: Colors.red));
                                        });
                                    // }
                                  } else {
                                    // List<CartProduct> produtos = context.read<CartManager>().items;
                                    // if (formKey.currentState!.validate()) {
                                    //   formKey.currentState!.save();
                                    //   checkoutManager.checkoutMP(
                                    //       produtos: produtos,
                                    //       onEstoqueFalha: (e) {
                                    //         Navigator.of(context).popUntil((route) => route.settings.name == '/cart');
                                    //       },
                                    //       onSuccess: (pedido) {
                                    //         Navigator.of(context).popUntil((route) => route.settings.name == '/');
                                    //         Navigator.of(context).pushNamed('/confirmation', arguments: pedido);
                                    //       },
                                    //       onPagamentoFalha: (error) {
                                    //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    //             content: Text(error.toUpperCase() as String,
                                    //                 style: const TextStyle(
                                    //                   fontWeight: FontWeight.bold,
                                    //                 )),
                                    //             backgroundColor: Colors.red));
                                    //       });
                                    // }
                                  }
                                })
                              ],
                            )),
                  )),
              ListTipoPagamento(groupValue: tipoPagamgento),
              Consumer<CheckoutManager>(builder: (_, checkoutManager, __) {
                if (checkoutManager.loading) return LoadingHelper(texto: 'DADOS DE PAGAMENTO...');
                return Container();
              })
            ]),
          ),
        ));
  }
}
