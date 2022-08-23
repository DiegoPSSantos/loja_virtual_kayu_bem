import 'package:cloud_firestore/cloud_firestore.dart';

class Configuracao {

  num? base;
  num? lat;
  num? long;
  num? maxkm;
  num? precokm;

  Configuracao.fromMap(DocumentSnapshot<Map<String, dynamic>> doc) {
    base = doc.data()!['base'] as num;
    lat = doc.data()!['lat'] as num;
    long = doc.data()!['long'] as num;
    maxkm = doc.data()!['maxkm'] as num;
    precokm = doc.data()!['precokm'] as num;
  }

  Map<String, dynamic> toMap(){
    return {
      'base': base,
      'lat': lat,
      'long': long,
      'maxkm': maxkm,
      'precokm': precokm
    };
  }

}