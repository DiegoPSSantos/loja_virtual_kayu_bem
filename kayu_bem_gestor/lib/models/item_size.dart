class ItemSize {

  ItemSize({this.nome, this.preco, this.estoque});

  ItemSize.fromMap(Map<String,dynamic> map) {
    nome = map['nome'] as String;
    preco = map['preco'] as num;
    estoque = map['estoque'] as int;
  }

  bool get estoqueDisponivel => estoque! > 0;

  String? nome;
  num? preco;
  int? estoque;

  Map<String, dynamic> toMap(){
    return {
      'nome': nome,
      'preco': preco,
      'estoque': estoque,
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return '{$nome, $preco, $estoque}';
  }

  ItemSize clone() {
    return ItemSize(nome: nome, estoque: estoque, preco: preco);
  }

}