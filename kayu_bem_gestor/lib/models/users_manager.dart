import 'dart:async';

import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/models/user_manager.dart';
import 'package:kayu_bem_gestor/models/usuario.dart';

class UsersManager extends ChangeNotifier {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;
  List<Usuario> usuarios = [];
  List<AlphaModel> get names => usuarios.map((usuario) => AlphaModel(usuario.name!)).toList();

  void atualizarUsuarios(UserManager userManager) {
    _subscription?.cancel();
    usuarios.clear();
    _listenToUsers();
  }

  void _listenToUsers() {
    _subscription = _firestore.collection('usuarios').snapshots().listen((snap) {
      usuarios = snap.docs.map((doc) => Usuario.fromDocument(doc)).toList();
      usuarios.sort((u1, u2) => u1.name!.toLowerCase().compareTo(u2.name!.toLowerCase()));
      notifyListeners();
    });
  }

}