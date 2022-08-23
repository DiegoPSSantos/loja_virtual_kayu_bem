import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kayu_bem/models/user_manager.dart';
import 'package:kayu_bem/models/usuario.dart';

import 'pedido.dart';

class PedidoManager extends ChangeNotifier {

  Usuario? usuario;
  List<Pedido> pedidos = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  void atualizarUsuario(UserManager userManager) {
    usuario = userManager.usuario;
    pedidos.clear();
    _subscription?.cancel();

    if (usuario != null) {
      _listenToPedidos();
    }
  }

  void _listenToPedidos() {
    _subscription = firestore.collection('pedidos')
        .where('usuario', isEqualTo: usuario!.uid)
        .snapshots().listen((event) {
          pedidos.clear();
          for (final doc in event.docs) {
            pedidos.add(Pedido.fromDocument(doc));
          }
        notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}