import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kayu_bem_gestor/services/cielo_payment.dart';


import 'cart_manager.dart';
import 'credit_card.dart';
import 'pedido.dart';
import 'product.dart';

class CheckoutManager extends ChangeNotifier {
  late CartManager cartManager;
  bool _loading = false;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CieloPayment pagamento = CieloPayment();

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // ignore: use_setters_to_change_properties
  void atualizarCarrinho(CartManager cartManager) {
    this.cartManager = cartManager;
  }

  Future<void> checkout(
      {CreditCard? creditCard,
      Function? onEstoqueFalha,
      Function? onSuccess,
      Function? onPagamentoFalha}) async {
    loading = true;

    final numeroPedido = await _getPedidoId();
    String pagamentoId;

    try {
      pagamentoId = await pagamento.autorizacao(
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
      pagamento.cancelar(pagamentoId);
      onEstoqueFalha!(e);
      loading = false;
      return;
    }

    try {
      await pagamento.captura(pagamentoId);
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
          final doc = await tx.get(firestore
              .doc('produtos/categorias/${item.categoria}/${item.produtoId}'));
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
        tx.update(
            firestore
                .doc('produtos/categorias/${produto.categoria}/${produto.id}'),
            {'tamanhos': produto.exportarListaTamnhos()});
      }
    });
  }
}
