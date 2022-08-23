import 'dart:collection';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:kayu_bem/helpers/image_helper.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/cart_product.dart';
import 'package:kayu_bem/models/usuario.dart';
import 'package:kayu_bem/services/mercadopago_payment.dart';

class PIXPayment {
  final functions = FirebaseFunctions.instance;

  Future<Map<String, dynamic>> getPixQRCode(
      {required num total, required List<CartProduct> produtos, required Usuario usuario}) async {
    try {
      final List items = converterListaProdutos(produtos);
      final Map<String, dynamic> dadosComprador = {
        'entity_type': 'individual',
        'email': usuario.email,
        'first_name': StringHelper.getPrimeiroNome(usuario.name!),
        'last_name': StringHelper.getUltimoNome(usuario.name!),
        'identification': {'type': 'CPF', 'number': usuario.cpf},
      };
      final Map<String, dynamic> venda = {
        'payment_method_id': 'pix',
        'transaction_amount': double.parse(total.toStringAsFixed(2)),
        'description': 'Pagamento via PIX',
        'payer': dadosComprador,
        'additional_info': {
          'items': items
        }
      };

      final HttpsCallable callable = functions.httpsCallable('pagamento-getQRCodePix');
      final response = await callable.call(venda);
      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);
      if (data['success'] as bool) {
        return data;
      } else {
        debugPrint('${data['error']['message']}');
        return Future.error(data['error']['message'] as String);
      }
    } catch (e) {
      debugPrint('$e');
      return Future.error('Falha ao finalizar transação. Favor entre em contato pelo email de suporte.');
    }
  }

  Future<String> confirmarTransacaoPIX({required ImageHelper anexo}) async {
    try {
      final Map<String, dynamic> comprovante = {'urlComprovante': anexo.url, 'bucket': anexo.bucket};

      final HttpsCallable callable = functions.httpsCallable('pagamento-confirmPIXTransaction');
      final response = await callable.call(comprovante);
      final data = Map<String, dynamic>.from(response.data as LinkedHashMap);

      if (data['success'] as bool) {
        return data['paymentId'] as String;
      } else {
        debugPrint('${data['error']['message']}');
        return Future.error(data['error']['message'] as String);
      }
    } catch (e) {
      debugPrint('$e');
      return Future.error('Falha ao confirmar transação. Favor entre em contato pelo email de suporte.');
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
        'unit_price': produto.precoUnitario
      };
      items.add(item);
    }
    return items;
  }
}
