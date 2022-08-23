import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:kayu_bem_gestor/helpers/string_helpers.dart';

import 'cart_manager.dart';
import 'cart_product.dart';
import 'endereco.dart';

enum Status { cancelado, em_preparacao, transporte, entregue }

class Pedido {
  Pedido.fromCartManager(CartManager cartManager)
      :
        // duplicação da lista, não somente criando outra referência para ela
        items = List.from(cartManager.items),
        preco = cartManager.precoTotal,
        usuarioId = cartManager.usuario!.uid!,
        status = Status.em_preparacao,
        enderecoEntrega = cartManager.endereco!;

  Pedido.fromDocument(DocumentSnapshot ds)
      : pedidoId = ds.id,
        items = (ds.get('items') as List<dynamic>)
            .map((item) => CartProduct.fromMap(item as Map<String, dynamic>))
            .toList(),
        preco = ds.get('preco') as num,
        usuarioId = ds.get('usuario') as String,
        enderecoEntrega =
            Endereco.fromMap(ds.get('entrega') as Map<String, dynamic>),
        data = ds.get('data') as Timestamp,
        pagamentoId = ds.get('pagamentoId') as String,
        status = Status.values[ds.get('status') as int];

  String? pedidoId;
  String? pagamentoId;
  String usuarioId;
  List<CartProduct> items;
  num preco;
  Endereco enderecoEntrega;
  Timestamp? data;
  Status status;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  DocumentReference get firestoreRef => firestore.collection('pedidos').doc(pedidoId);

  void updateFromDocument(DocumentSnapshot doc) {
    status = Status.values[doc.get('status') as int];
  }

  Future<void> save() async {
    firestore.collection('pedidos').doc(pedidoId).set({
      'items': items.map((item) => item.converterPedidoMap()).toList(),
      'preco': preco,
      'usuario': usuarioId,
      'entrega': enderecoEntrega.toMap(),
      'status': status.index,
      'pagamentoId': pagamentoId,
      'data': Timestamp.now()
    });
  }

  String get idFormatado => '#${pedidoId!.padLeft(6, '0')}';

  String get statusText => getStatusText(status);

  static String getStatusText(Status status) {
    switch (status) {
      case Status.cancelado:
        return StringHelper.STATUS_PEDIDO_0;
      case Status.em_preparacao:
        return StringHelper.STATUS_PEDIDO_1;
      case Status.transporte:
        return StringHelper.STATUS_PEDIDO_2;
      case Status.entregue:
        return StringHelper.STATUS_PEDIDO_3;
      default:
        return StringHelper.VAZIO;
    }
  }

  String dataHoraToString() {
    final dt =
        DateTime.fromMicrosecondsSinceEpoch(data!.microsecondsSinceEpoch);
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  Function()? get avancar {
    return status != Status.cancelado && status.index <= Status.transporte.index ?
        () {
      status = Status.values[status.index + 1];
      firestoreRef.update({ 'status' : status.index });
        } : null;
  }

  Function()? get recuar {
    return status != Status.cancelado && status.index >= Status.transporte.index ?
    () {
      status = Status.values[status.index - 1];
      firestoreRef.update({ 'status' : status.index });
    } : null;
  }

  void cancelar() {
    status = Status.cancelado;
    firestoreRef.update({ 'status' : status.index });
  }

}
