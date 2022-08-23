import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'endereco.dart';

class Usuario {
  Usuario({this.uid, this.name, this.email, this.senha, this.confirmarSenha});

  Usuario.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    uid = doc.id;
    name = doc.data()!['name'] as String;
    email = doc.data()!['email'] as String;
    if (doc.data()!.containsKey('cpf')) {
      cpf = doc.data()!['cpf'] as String;
    }
    if (doc.data()!.containsKey('telefone')) {
      telefone = doc.data()!['telefone'] as String;
    }
    if (doc.data()!.containsKey('endereco')) {
      endereco =
          Endereco.fromMap(doc.data()!['endereco'] as Map<String, dynamic>);
    }
  }

  String? uid;
  String? cpf;
  String? name;
  String? email;
  String? senha;
  String? telefone;
  String? confirmarSenha;
  Endereco? endereco;

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.collection('usuarios').doc(uid);

  CollectionReference get cartRef => firestoreRef.collection('carrinho');
  CollectionReference get tokensRef => firestoreRef.collection('tokens');

  Future<void> saveData() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (cpf != null) 'cpf': cpf,
      if (endereco != null) 'endereco': endereco!.toMap()
    };
  }

  Future<void> setEndereco(Endereco endereco) async {
    this.endereco = endereco;
    saveData();
  }

  void setCPF(String? cpf) {
    this.cpf = cpf;
    saveData();
  }

  Future<void> saveToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    print(token);
    tokensRef.doc(token).set({
      'token': token,
      'ultimaAtualizacao': FieldValue.serverTimestamp(),
      'plataforma': Platform.operatingSystem,
    });
  }
}
