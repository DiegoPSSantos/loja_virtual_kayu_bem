import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'configuracao.dart';

class ConfiguracaoManager extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Configuracao? configuracao;
  bool _loading = false;
  bool _success = false;

  ConfiguracaoManager() {
    _loadConfiguracao();
  }

  bool get loading => _loading;
  set loading(bool value) => _loading = value;

  bool get success => _success;
  set success(bool value) => _success = value;

  void setBase(String? valor) {
    configuracao!.base = num.tryParse(valor!);
  }

  void setLat(String? valor) {
    configuracao!.lat = num.tryParse(valor!);
  }

  void setLong(String? valor) {
    configuracao!.long = num.tryParse(valor!);
  }

  void setRaio(String? valor) {
    configuracao!.maxkm = num.tryParse(valor!);
  }

  void setPrecoKM(String? valor) {
    configuracao!.precokm = num.tryParse(valor!);
  }

  Future<void> _loadConfiguracao() async {
    final DocumentSnapshot<Map<String, dynamic>> snapshotAux = await firestore.collection('aux').doc('entrega').get();

    configuracao = Configuracao.fromMap(snapshotAux);

    notifyListeners();
  }

  Future<void> saveData() async {
    loading = true;

    try {
      await firestore.collection('aux').doc('entrega').set(configuracao!.toMap());
      success = true;
      loading = false;
    } catch (e) {
      success = false;
      loading = false;
    }

    notifyListeners();
  }
}
