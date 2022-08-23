import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/helpers/string_helpers.dart';

import 'product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    loadProductsCategory(StringHelper.PATH_CATEGORIA_1);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();
  final functions = FirebaseFunctions.instance;

  List<Product> allProducts = [];

  String? _categoria;

  set categoria(String value) => _categoria = value;

  String get categoria => _categoria!;

  String _search = '';

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  String get search => _search;

  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];

    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(allProducts
          .where((p) => p.nome!.toLowerCase().contains(search.toLowerCase())));
    }

    return filteredProducts;
  }

  Future<void> loadProductsCategory(String categoria) async {
    loading = true;

    _categoria = categoria;
    final QuerySnapshot<Map<String, dynamic>> snapshotProducts =
        await _firestore
            .collection('produtos')
            .doc('categorias')
            .collection(categoria)
            .get();

    allProducts =
        snapshotProducts.docs.map((doc) => Product.fromDocument(doc)).toList();

    loading = false;
  }

  Future<Product?> encontrarProdutoPorID(String categoria, String id) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshotProduct =
          await _firestore
              .collection('produtos')
              .doc('categorias')
              .collection(categoria)
              .doc(id)
              .get();

      return Product.fromDocument(snapshotProduct);

      // return allProducts.firstWhere((p) => p.id!.compareTo(id) == 0);
    } catch (ex) {
      return null;
    }
  }

  Future<void> removerProdutos() async {
    loading = true;

    List<Product> produtosRemover = List.from(allProducts);

    int c = 0;
    allProducts.forEach((p) async {
      c++;
      if (p.remove) {
        await _firestore
            .collection('produtos')
            .doc('categorias')
            .collection(categoria)
            .doc(p.id)
            .delete();
        produtosRemover.remove(p);
      }
      if (c == allProducts.length) {
        allProducts.clear();
        allProducts = List.from(produtosRemover);
        allProducts.sort((p1, p2) => p1.nome!.compareTo(p2.nome!));
      }
    });

    loading = false;
  }

  void update(Product produto) {
    // MUDOU A CATEGORIA REMOVE O PRODUTO
    if (produto.novaCategoria != null &&
        produto.categoria!.compareTo(produto.novaCategoria!) != 0) {
      if (produto.novoId != null) {
        allProducts.removeWhere((p) => p.id == produto.id);
      }
    } else {
      if (allProducts.isNotEmpty) {
        try {
          final p = allProducts.firstWhere((p) => p.id == produto.id);
          allProducts.remove(p);
        } catch (ex) {
          print('[PRODUTO NÃO ENCONTRADO NA LISTA]');
        }
      }
      allProducts.add(produto);
      allProducts.sort((p1, p2) => p1.nome!.compareTo(p2.nome!));
    }

    notifyListeners();
  }
}
