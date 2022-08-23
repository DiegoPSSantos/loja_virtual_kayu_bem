import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kayu_bem_gestor/models/usuario.dart';

import 'pedido.dart';

class PedidoManager extends ChangeNotifier {
  final List<Pedido> _pedidos = [];
  List<Status> statusFilter = [Status.em_preparacao];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;

  Usuario? usuarioFilter;

  void atualizarPedidos() {
    _pedidos.clear();
    _subscription?.cancel();
    _listenToPedidos();
  }

  List<Pedido> get pedidosFiltrados {
    List<Pedido> saida = _pedidos.reversed.toList();

    if (usuarioFilter != null) {
      saida = saida.where((p) => p.usuarioId == usuarioFilter!.uid).toList();
    }

    return saida.where((p) => statusFilter.contains(p.status)).toList();
  }

  void setStatusFilter({required Status status, required bool enabled}) {
    if (enabled) {
      statusFilter.add(status);
    } else {
      statusFilter.remove(status);
    }
    notifyListeners();
  }

  void _listenToPedidos() {
    _subscription = firestore.collection('pedidos').snapshots().listen((event) {
      // pedidos.clear();
      for (final change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            _pedidos.add(Pedido.fromDocument(change.doc));
            break;
          case DocumentChangeType.modified:
            final pedidoModificado = _pedidos.firstWhere((p) => p.pedidoId == change.doc.id);
            pedidoModificado.updateFromDocument(change.doc);
            break;
          case DocumentChangeType.removed:
            // TODO: Handle this case.
            break;
        }

      }
      notifyListeners();
    });
  }

  void setUsuarioFilter(Usuario? usuario) {
    usuarioFilter = usuario;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }
}
