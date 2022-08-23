import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/cart_product.dart';
import 'package:kayu_bem/models/meio_pagamento.dart';
import 'package:kayu_bem/models/parcela.dart';
import 'package:mercadopago_sdk/mercadopago_sdk.dart';

import 'package:mercado_pago_mobile_checkout/mercado_pago_mobile_checkout.dart';

class MercadoPagoPayment {
  final functions = FirebaseFunctions.instance;

  Future<MP> getInstanceMP() async {
    final HttpsCallable callable = functions.httpsCallable('pagamento-getToken');
    final response = await callable.call();
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    final String token = data['token'] as String;
    return MP.fromAccessToken(token);
  }

  Future<String> getPreference({required String pedidoId, required List<CartProduct> produtos}) async {
    try {
      final Map<String, dynamic> dadosVenda = {'items': converterListaProdutos(produtos)};

      final HttpsCallable callable = functions.httpsCallable('pagamento-getPreferenceId');
      final response = await callable.call(dadosVenda);
      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

      if (data['success'] as bool) {
        return data['preferenceId'] as String;
      } else {
        debugPrint('${data['error']['message']}');
        return Future.error(data['error']['message'] as String);
      }
    } catch (e) {
      debugPrint('$e');
      return Future.error('Falha ao processar transação. Tente novamente.');
    }
  }

  Future<Parcela> getParcelas(String bin, num total) async {
    try {
      final Map<String, dynamic> dadosCartao = {
        'bin': bin,
        'amount': total.toStringAsFixed(2)
      };

      final HttpsCallable callable = functions.httpsCallable('pagamento-getParcelasCartaoCredito');
      final response = await callable.call(dadosCartao);
      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

      if (data['success'] as bool) {
        Parcela parcela = Parcela.fromMap(data['parcelas'] as Map<String, dynamic>);
        return parcela;
      } else {
        return Parcela();
      }
    } catch (e) {
      debugPrint('$e');
      return Future.error('Falha ao recuperar parcelas. Tente novamente.');
    }
  }

  Future<List<MeioPagamento>> getMeiosPagamento() async {
    try {
      final HttpsCallable callable = functions.httpsCallable('pagamento-getMeiosPagamento');
      final response = await callable.call();
      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

      if (data['meios_pagamento'] != null) {
        List<MeioPagamento> mps =
        (data['meios_pagamento'] as List).map((mp) => MeioPagamento.fromMap(mp as Map<dynamic, dynamic>)).toList();
        return mps;
      } else {
        return Future.error('Não há meios de pagamento autorizados');
      }
    } catch (e) {
      debugPrint('$e');
      return Future.error('Falha ao meios de pagamento. Tente novamente.');
    }
  }

  List converterListaProdutos(List<CartProduct> produtos) {
    List items = [];
    for (CartProduct produto in produtos) {
      var item = {
        'id': produto.produtoId,
        'title': produto.nome,
        'picture_url': produto.urlImagem,
        'category_id': produto.categoria,
        'quantity': produto.quantidade,
        'currency_id': 'BRL',
        'unit_price': produto.precoUnitario
      };
      items.add(item);
    }
    return items;
  }

  Future<void> captura(String preferenceId) async {
    final Map<String, dynamic> dadosPagamento = {'payId': preferenceId};


    await MercadoPagoMobileCheckout.startCheckout(StringHelper.PUBLIC_KEY_MP, preferenceId);
    // PaymentResult result = await MercadoPagoMobileCheckout.startCheckout(StringHelper.PUBLIC_KEY_MP, preferenceId);
    // final HttpsCallable callable =
    // functions.httpsCallable('pagamento-captureCreditCard');
    // final response = await callable.call(dadosPagamento);
    // final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
    //
    // if (data['success'] as bool) {
    //   debugPrint('Captura realizada com sucesso!!!!');
    // } else {
    //   debugPrint('${data['error']['message']}');
    //   return Future.error(data['error']['message'] as String);
    // }
  }
}
