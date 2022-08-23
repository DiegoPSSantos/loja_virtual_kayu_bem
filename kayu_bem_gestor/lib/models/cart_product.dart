import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kayu_bem_gestor/helpers/image_helper.dart';

import 'item_size.dart';
import 'product.dart';

class CartProduct extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CartProduct.fromProduct(this._produto) {
    produtoId = produto.id!;
    quantidade = 1;
    nome = produto.nome!;
    tamanho = produto.tamanhoSelecionado.nome!;
    urlImagem = (produto.imagens! as List<ImageHelper>).first.url!;
    categoria = produto.categoria!;
  }

  CartProduct.fromDocument(DocumentSnapshot ds) {
    id = ds.id;
    nome = ds.get('nome') as String;
    produtoId = ds.get('pid') as String;
    quantidade = ds.get('quantidade') as int;
    tamanho = ds.get('tamanho') as String;
    urlImagem = ds.get('urlImagem') as String;
    categoria = ds.get('categoria') as String;

    setProduto();
  }

  CartProduct.fromMap(Map<String, dynamic> map) {
    produtoId = map['pid'] as String;
    nome = map['nome'] as String;
    quantidade = map['quantidade'] as int;
    tamanho = map['tamanho'] as String;
    urlImagem = map['urlImagem'] as String;
    categoria = map['categoria'] as String;
    precoFixo = map['precoFixo'] as num;

    setProduto();
  }

  String? id;
  Product? _produto;
  late String produtoId;
  late String tamanho;
  late String categoria;
  late int quantidade;
  late String urlImagem;
  late String nome;
  num? precoFixo;

  Product get produto => _produto!;

  set produto(Product value) {
    _produto = value;
    notifyListeners();
  }

  void setProduto() {
    if (produtoId.isNotEmpty) {
      firestore.doc('produtos/categorias/$categoria/$produtoId').get().then((p) {
        if (p.exists) {
          produto = Product.fromDocument(p);
        } else {
          produto = Product(
              nome: nome,
              categoria: categoria,
              tamanhos: [ItemSize(nome: tamanho)],
              imagens: [ImageHelper(url: urlImagem)]);
        }
      });
    } else {
      produto = Product(
          nome: nome,
          categoria: categoria,
          tamanhos: [ItemSize(nome: tamanho)],
          imagens: [ImageHelper(url: urlImagem)]);
    }
  }

  ItemSize? get tamanhoItem {
    return produto.encontrarTamanho(tamanho);
  }

  num get precoUnitario {
    return tamanhoItem!.preco ?? 0;
  }

  num get precoTotal {
    return tamanhoItem!.preco! * quantidade;
  }

  Map<String, dynamic> converterCarrinhoMap() =>
      {'pid': produtoId, 'quantidade': quantidade, 'tamanho': tamanho, 'categoria': categoria};

  bool verificarProdutoJaAdicionado(Product produto) =>
      produto.id!.compareTo(produtoId) == 0 && produto.tamanhoSelecionado.nome!.compareTo(tamanho) == 0;

  void incrementar() {
    quantidade++;
    notifyListeners();
  }

  void decrementar() {
    if (quantidade > 0) {
      quantidade--;
      notifyListeners();
    }
  }

  bool get estoqueDisponivel {
    final t = tamanhoItem;
    if (t == null) return false;
    return tamanhoItem!.estoque! >= quantidade;
  }

  Map<String, dynamic> converterPedidoMap() {
    return {
      'pid': produtoId,
      'quantidade': quantidade,
      'tamanho': tamanho,
      'categoria': categoria,
      'precoFixo': precoFixo ?? precoUnitario
    };
  }
}
