import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:kayu_bem/models/credit_card.dart';
import 'package:kayu_bem/models/usuario.dart';

class CieloPayment {
  final functions = FirebaseFunctions.instance;

  Future<String> autorizacao(
      {required CreditCard creditCard,
        required num preco,
        required String pedidoId,
        required Usuario usuario}) async {
    try {
      final Map<String, dynamic> dadosVenda = {
        'merchantOrderId': pedidoId,
        'amount': (preco * 100).toInt(),
        'softDescriptor': 'Kayu Bem',
        // Limite máximo de 13 caracteres, nome da loja
        'installments': 1,
        // Total de parcelamento, pode ser alterado caso o cliente queira
        'creditCard': creditCard.toJson(),
        'cpf': usuario.cpf,
        'paymentType': 'CreditCard',
        'gateway': 'Cielo'
      };

      final HttpsCallable callable =
      functions.httpsCallable('pagamento-authorizeCreditCard');
      final response = await callable.call(dadosVenda);
      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

      if (data['success'] as bool) {
        return data['paymentId'] as String;
      } else {
        debugPrint('${data['error']['message']}');
        return Future.error(data['error']['message'] as String);
      }
    } catch (e) {
      debugPrint('$e');
      return Future.error('Falha ao processar transação. Tente novamente.');
    }
  }

  Future<void> captura(String payId) async {
    final Map<String, dynamic> dadosPagamento = {
      'payId': payId
    };

    final HttpsCallable callable =
    functions.httpsCallable('pagamento-captureCreditCard');
    final response = await callable.call(dadosPagamento);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (data['success'] as bool) {
      debugPrint('Captura realizada com sucesso!!!!');
    } else {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message'] as String);
    }
  }

  Future<void> cancelar(String payId) async {
    final Map<String, dynamic> dadosCancelamento = {
      'payId': payId
    };

    final HttpsCallable callable =
    functions.httpsCallable('pagamento-cancelSale');
    final response = await callable.call(dadosCancelamento);
    final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

    if (data['success'] as bool) {
      debugPrint('Cancelamento realizado com sucesso!!!!');
    } else {
      debugPrint('${data['error']['message']}');
      return Future.error(data['error']['message'] as String);
    }
  }
}
