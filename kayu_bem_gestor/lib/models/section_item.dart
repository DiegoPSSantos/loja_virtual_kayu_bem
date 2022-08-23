class SectionItem {
  SectionItem.fromMap(Map<String, dynamic> map) {
    imagem = map['imagem'] as String;
    categoria = map['categoria'] as String;
    if (map.containsKey('produto')) {
      produto = map['produto'] as String;
    }
    if (map.containsKey('quantidade')) {
      quantidade = map['quantidade'] as int;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'imagem': imagem,
      'produto': produto,
      'categoria': categoria
    };
  }

  SectionItem({this.imagem, this.produto, this.categoria});

  String? imagem;
  String? produto;
  String? categoria;
  int? quantidade;
}
