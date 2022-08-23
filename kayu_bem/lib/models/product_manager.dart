import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/product.dart';

class ProductManager extends ChangeNotifier {
  ProductManager() {
    loadProductsCategory(StringHelper.PATH_CATEGORIA_1);
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Reference storageReference = FirebaseStorage.instance.ref();
  bool _loading = false;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  List<Product> allProducts = [];

  String _search = '';

  set search(String value) {
    _search = value;
    notifyListeners();
  }

  String get search => _search;

  List<Product> get filteredProducts {
    final List<Product> filteredProducts = [];

    if (search.isEmpty) {
      filteredProducts.addAll(allProducts);
    } else {
      filteredProducts.addAll(allProducts.where((p) => p.nome!.toLowerCase().contains(search.toLowerCase())));
    }

    return filteredProducts;
  }

  Future<void> loadProductsCategory(String categoria) async {
    _firestore
        .collection('produtos')
        .doc('categorias')
        .collection(categoria)
        .snapshots().listen((snapshot) {
          allProducts = snapshot.docs.map((doc) => Product.fromDocument(doc)).toList();
          notifyListeners();
    });
  }

  Future<Product?> encontrarProdutoPorID(String id, String categoria) async {
    loading = true;

    await loadProductsCategory(categoria);
    try {
      loading = false;
      return allProducts.firstWhere((p) => p.id!.compareTo(id) == 0);
    } catch (ex) {
      return null;
    }
  }
}
