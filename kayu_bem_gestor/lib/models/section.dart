import 'package:cloud_firestore/cloud_firestore.dart';

import 'section_item.dart';

class Section {

  Section.fromDocument(DocumentSnapshot doc) {
    nome = doc.get('nome') as String;
    tipo = doc.get('tipo') as String;
    items = (doc.get('items') as List)
        .map((item) => SectionItem.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'tipo': tipo,
      'items': items!.map((item) => item.toMap()).toList()
    };
  }

  String? nome;
  String? tipo;
  List<SectionItem>? items;
}