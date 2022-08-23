class MeioPagamento {

  MeioPagamento.fromMap(Map<dynamic,dynamic> map) {
    id = map['id'] as String;
    name = map['name'] as String;
    paymentTypeId = map['payment_type_id'] as String;
    thumbnail = map['thumbnail'] as String;
  }

  String? id;
  String? name;
  String? paymentTypeId;
  String? thumbnail;

}