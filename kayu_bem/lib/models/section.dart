import 'package:cloud_firestore/cloud_firestore.dart';

import 'section_item.dart';

class Section {

  Section.fromDocument(DocumentSnapshot doc) {
    nome = doc.get('nome') as String;
    tipo = doc.get('tipo') as String;
    ordem = doc.get('ordem') as num;
    items = (doc.get('items') as List)
        .map((item) => SectionItem.fromMap(item as Map<String, dynamic>))
        .toList();
  }

  String? nome;
  String? tipo;
  num? ordem;
  List<SectionItem>? items;
}