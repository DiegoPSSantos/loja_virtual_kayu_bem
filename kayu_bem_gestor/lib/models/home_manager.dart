import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kayu_bem_gestor/models/section_item.dart';

import 'section.dart';

class HomeManager extends ChangeNotifier {

  HomeManager() {
    _loadSections();
  }
  
  List<Section> sections = [];

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void>_loadSections() async{
    firestore.collection('home').orderBy('ordem').snapshots().listen((snapshot) {
      sections.clear();
      for (final DocumentSnapshot ds in snapshot.docs) {
        sections.add(Section.fromDocument(ds));
      }
      _ordenarProdutosEmAlta();
      notifyListeners();
    });
  }

  void _ordenarProdutosEmAlta() {
    var produtosEmAlta = sections.firstWhere((secao) => secao.nome!.compareTo('Produtos em Alta') == 0);
    produtosEmAlta.items!.sort((SectionItem item1, SectionItem item2) => item1.quantidade!.compareTo(item2
        .quantidade!));
  }

}
