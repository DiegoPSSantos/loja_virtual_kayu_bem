class Endereco {

  Endereco({this.rua, this.numero, this.complemento, this.bairro, this.cep,
      this.cidade, this.uf, this.lat, this.long});

  Endereco.fromMap(Map<String, dynamic> map) {
    rua = map['rua'] as String;
    numero = map['numero'] as String;
    complemento = map['complemento'] as String;
    bairro = map['bairro'] as String;
    cep = map['cep'] as String;
    cidade = map['cidade'] as String;
    uf = map['uf'] as String;
    lat = map['lat'] as double;
    long = map['long'] as double;
  }

  String? rua;
  String? numero;
  String? complemento;
  String? bairro;
  String? cep;
  String? cidade;
  String? uf;

  double? lat;
  double? long;

  Map<String, dynamic> toMap() {
    return {
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cep': cep,
      'cidade': cidade,
      'uf': uf,
      'lat': lat,
      'long': long
    };
  }

}