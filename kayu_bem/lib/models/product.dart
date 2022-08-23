import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kayu_bem/helpers/image_helper.dart';
import 'package:kayu_bem/models/item_size.dart';

class Product extends ChangeNotifier {
  Product({this.nome, this.imagens, this.tamanhos, this.categoria});

  Product.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    id = doc.id;
    nome = doc.data()!['nome'] as String;
    descricao = doc.data()!['descricao'] as String;
    imagens = List.from(doc.data()!['imagens'] as List<dynamic>)
        .map((imageData) => ImageHelper.fromMap(imageData as Map<String, dynamic>)).toList();
    tamanhos = (doc.data()!['tamanhos'] as List<dynamic>)
        .map((t) => ItemSize.fromMap(t as Map<String, dynamic>))
        .toList();
    categoria = doc.reference.parent.path.split('/').last;
  }

  String? id;
  String? nome;
  String? descricao;
  String? categoria;
  List<ImageHelper>? imagens;
  List<ItemSize>? tamanhos;
  ItemSize? _tamanhoSelecionado;

  ItemSize get tamanhoSelecionado => _tamanhoSelecionado!;

  bool get existeTamanhoSelecionado {
    bool retorno;
    try {
      retorno = _tamanhoSelecionado!.estoqueDisponivel;
    } catch (ex) {
      retorno = false;
    }
    return retorno;
  }

 int get totalEstoque {
    int estoque = 0;
    for (final tamanho in tamanhos!) {
      estoque += tamanho.estoque!;
    }
    return estoque;
 }

 bool get estoqueDisponivel {
    return totalEstoque > 0;
 }

  set tamanhoSelecionado(ItemSize t) {
    _tamanhoSelecionado = t;
    notifyListeners();
  }

  ItemSize? encontrarTamanho(String nome) {
    try {
      return tamanhos!.firstWhere((t) => t.nome!.compareTo(nome) == 0);
    } catch (e) {
      return ItemSize();
    }
  }

  List<Map<String, dynamic>> exportarListaTamnhos(){
    return tamanhos!.map((tamanho) => tamanho.toMap()).toList();
  }

  num encontrarMenorPreco() {
    tamanhos!.sort((t1, t2) => t1.preco!.compareTo(t2.preco!));
    return tamanhos!.first.preco!;
  }
}
