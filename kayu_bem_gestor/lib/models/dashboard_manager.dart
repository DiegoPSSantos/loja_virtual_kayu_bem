import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/models/cart_product.dart';
import 'package:kayu_bem_gestor/screens/products/components/category_list.dart';

import 'configuracao.dart';
import 'pedido.dart';

class DashboardManager extends ChangeNotifier {

  DashboardManager() {
    consultarCategoriasMaisVendidas();
    consultarLocalizacaoPontoVenda();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var categorias = Map<String, int>();
  int total = 0;
  late num latitude;
  late num longitude;

  Future<void> consultarLocalizacaoPontoVenda() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshotAux = await _firestore.collection('aux').doc('entrega').get();

    Configuracao configuracao = Configuracao.fromMap(snapshotAux);
    latitude = configuracao.lat!;
    longitude = configuracao.long!;
    notifyListeners();
  }

  void consultarCategoriasMaisVendidas() {
    List<Pedido> pedidos = [];
    _firestore.collection('pedidos').snapshots().listen((snapshot) {
      for (final DocumentSnapshot ds in snapshot.docs) {
         pedidos.add(Pedido.fromDocument(ds));
      }
      _contabilizarPorCategoria(pedidos);
      _calcularTotal();
      notifyListeners();
    });
  }

  void _calcularTotal() {
    for (final quantidade in categorias.values) {
      total += quantidade;
    }
  }

  void _contabilizarPorCategoria(List<Pedido> pedidos) {
    for (Pedido p in pedidos) {
      for (CartProduct produto in p.items) {
        var categoria = CategoryList.getNomeCategoria(produto.categoria.trim());
        if (categorias.isEmpty) {
          categorias.putIfAbsent(categoria, () => 1);
        } else {
          if (categorias.containsKey(categoria)) {
              int total = categorias.entries.first.value;
              categorias.update(categoria, (value) => ++total);
          } else {
            categorias.putIfAbsent(categoria, () => 1);
          }
        }
      }
    }
  }
}