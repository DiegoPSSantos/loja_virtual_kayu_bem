import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:kayu_bem/helpers/image_helper.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/cart_manager.dart';
import 'package:kayu_bem/models/cart_product.dart';
import 'package:kayu_bem/models/meio_pagamento.dart';
import 'package:kayu_bem/models/pedido.dart';
import 'package:kayu_bem/models/product.dart';
import 'package:kayu_bem/services/cielo_payment.dart';
import 'package:kayu_bem/services/mercadopago_payment.dart';
import 'package:kayu_bem/services/pix_payment.dart';
import 'package:uuid/uuid.dart';

import 'credit_card.dart';
import 'parcela.dart';
import 'usuario.dart';

class CheckoutManager extends ChangeNotifier {
  CheckoutManager() {
    setCartoesAceitos();
  }

  late CartManager cartManager;
  bool _loading = false;
  bool _loadingCartoesAceitos = false;
  int _tipoPagamento = 0;
  File? _comprovante;
  Parcela? parcela;
  List<MeioPagamento>? cartoesCreditoAceitos;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseStorage storage = FirebaseStorage.instance;
  final CieloPayment pagamentoCC = CieloPayment();
  final MercadoPagoPayment pagamentoMP = MercadoPagoPayment();
  final PIXPayment pagamentoPIX = PIXPayment();
  final functions = FirebaseFunctions.instance;

  bool get loading => _loading;

  bool get loadingCartoes => _loadingCartoesAceitos;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  set loadingCartoes(bool value) {
    _loadingCartoesAceitos = value;
    notifyListeners();
  }

  File get comprovante => _comprovante!;

  set comprovante(File value) {
    _comprovante = value;
  }

  int get tipoPagamento => _tipoPagamento;

  void setTipoPagamento(int value) {
    _tipoPagamento = value;
    notifyListeners();
  }

  // ignore: use_setters_to_change_properties
  void atualizarCarrinho(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  void consultarParcelas(String bin, num total) async {
    loading = true;
    parcela = await pagamentoMP.getParcelas(bin, total);
    loading = false;
  }

  Future<ImageHelper> _uploadImagem() async {
    final UploadTask task = storage.ref().child('comprovantes').child(const Uuid().v1()).putFile(comprovante!);
    final Reference ref = (await task).ref;
    final url = await ref.getDownloadURL();
    return ImageHelper(url: url, bucket: ref.fullPath);
  }

  void setCartoesAceitos() async {
    loadingCartoes = true;
    List<MeioPagamento> mps = await pagamentoMP.getMeiosPagamento();
    cartoesCreditoAceitos = mps.where((mp) => mp.paymentTypeId!.compareTo(StringHelper.CREDIT_CARD_TYPE) == 0).toList();
    loadingCartoes = false;
  }

  Future<void> gerarQRCode({required List<CartProduct> produtos, required Usuario usuario}) async {
    try {
      var pagamento =
          await pagamentoPIX.getPixQRCode(total: cartManager.precoTotal, produtos: produtos, usuario: usuario);
      print(pagamento);
    } catch (e) {
      loading = false;
      return;
    }
  }

  Future<void> checkoutPIX({Function? onEstoqueFalha, Function? onSuccess, Function? onPagamentoFalha}) async {
    loading = true;

    try {
      await _decrementarEstoque();
    } catch (e) {
      onEstoqueFalha!(e);
      loading = false;
      return;
    }

    if (_comprovante != null) {
      final numeroPedido = await _getPedidoId();
      String pagamentoId;

      ImageHelper ih = await _uploadImagem();

      try {
        pagamentoId = await pagamentoPIX.confirmarTransacaoPIX(anexo: ih);

        // UTILIZANDO API COM IA PARA OCR
        // var bytes = File(_comprovante!.path.toString()).readAsBytesSync();
        // String img64 = base64Encode(bytes);
        //
        // var url = Uri.parse(StringHelper.URL_API_OCR);
        // var payload = {"base64Image": "data:image/jpg;base64,${img64.toString()}"};
        // var header = {"apikey": 'a26db2ac0688957'};
        // var post = await http.post(url=url,body: payload,headers: header);
        // var result = jsonDecode(post.body);
        // var parsedtext = result['ParsedResults'][0]['ParsedText'];
        // print(parsedtext);

        //================================================== GOOGLE VISION ==================================
        // final inputAnexo = InputImage.fromFile(_comprovante!);
        // final RecognisedText rt = await textDectetor.processImage(inputAnexo);
        // String text = rt.text;
        // print('[TEXTO]: ' + text);
        // for (TextBlock bloco in rt.blocks) {
        //   print('[BLOCO]: ' + bloco.text);
        //   for (TextLine linha in bloco.lines) {
        //     print('[LINHA]: ' + linha.text);
        //     for (TextElement palavra in linha.elements) {
        //       print('[PALAVRA]: ' + palavra.text);
        //     }
        //   }
        // }

        final pedido = Pedido.fromCartManager(cartManager);
        pedido.pedidoId = numeroPedido.toString();
        pedido.pagamentoId = pagamentoId;

        await pedido.save();

        cartManager.limparCarrinho();

        onSuccess!(pedido);
      } catch (e) {
        onPagamentoFalha!(e);
        loading = false;
        return;
      }
    }

    loading = false;
  }

  Future<void> checkoutMercadoPagoCC(
      {CreditCard? creditCard,
      double? taxaEntrega,
      List<CartProduct>? produtos,
      Function? onEstoqueFalha,
      Function? onSuccess,
      Function? onPagamentoFalha}) async {
    loading = true;

    final numeroPedido = await _getPedidoId();
    String preferenceId;

    try {
      preferenceId = await pagamentoMP.getPreference(produtos: produtos!, pedidoId: numeroPedido.toString());
    } catch (e) {
      loading = false;
      return;
    }

    try {
      await pagamentoMP.captura(preferenceId);
      print('success');
      loading = false;
    } catch (e) {
      onPagamentoFalha!(e);
      loading = false;
      return;
    }
  }

  Future<void> checkout(
      {CreditCard? creditCard,
      List<CartProduct>? produtos,
      Function? onEstoqueFalha,
      Function? onSuccess,
      Function? onPagamentoFalha}) async {
    loading = true;

    final numeroPedido = await _getPedidoId();
    String pagamentoId;

    try {
      pagamentoId = await pagamentoCC.autorizacao(
          creditCard: creditCard!,
          preco: cartManager.precoTotal,
          pedidoId: numeroPedido.toString(),
          usuario: cartManager.usuario!);
    } catch (e) {
      onPagamentoFalha!(e);
      loading = false;
      return;
    }

    try {
      await _decrementarEstoque();
    } catch (e) {
      pagamentoCC.cancelar(pagamentoId);
      onEstoqueFalha!(e);
      loading = false;
      return;
    }

    try {
      await pagamentoCC.captura(pagamentoId);
      print('success');
    } catch (e) {
      onPagamentoFalha!(e);
      loading = false;
      return;
    }

    final pedido = Pedido.fromCartManager(cartManager);
    pedido.pedidoId = numeroPedido.toString();
    pedido.pagamentoId = pagamentoId;

    await pedido.save();

    cartManager.limparCarrinho();

    onSuccess!(pedido);
    loading = false;
  }

  Future<int> _getPedidoId() async {
    final ref = firestore.doc('aux/ordempedido');
    try {
      final resultado = await firestore.runTransaction((tx) async {
        final doc = await tx.get(ref);
        final pedidoAtual = doc.get('atual') as int;
        await tx.update(ref, {'atual': pedidoAtual + 1});
        return {'ordemPedido': pedidoAtual};
      });

      return resultado['ordemPedido']!;
    } catch (e) {
      debugPrint(e.toString());
      return Future.error('Falha ao gerar o número do pedido');
    }
  }

  Future<void> _decrementarEstoque() async {
    // 1. Ler todos os estoques
    // 2. Decrementar localmente os estoques
    // 3. Salvar os estoques no firebase

    return firestore.runTransaction((tx) async {
      final List<Product> produtosAtualizar = [];
      final List<Product> produtosSemEstoque = [];

      for (final item in cartManager.items) {
        Product produto;

        if (produtosAtualizar.any((p) => p.id == item.produtoId)) {
          produto = produtosAtualizar.firstWhere((p) => p.id == item.produtoId);
        } else {
          final doc = await tx.get(firestore.doc('produtos/categorias/${item.categoria}/${item.produtoId}'));
          produto = Product.fromDocument(doc);
        }

        item.produto = produto;

        final tamanho = produto.encontrarTamanho(item.tamanho);

        if (tamanho!.estoque! - item.quantidade < 0) {
          produtosSemEstoque.add(produto);
        } else {
          tamanho.estoque = tamanho.estoque! - item.quantidade;
          produtosAtualizar.add(produto);
        }
      }

      if (produtosSemEstoque.isNotEmpty) {
        return Future.error(
            "${produtosSemEstoque.length} produto${produtosSemEstoque.length == 1 ? '' : 's'} sem estoque!!!");
      }

      for (final produto in produtosAtualizar) {
        tx.update(firestore.doc('produtos/categorias/${produto.categoria}/${produto.id}'),
            {'tamanhos': produto.exportarListaTamnhos()});
      }
    });
  }
}
