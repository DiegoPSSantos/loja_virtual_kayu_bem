import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_insta/flutter_insta.dart';
import 'package:kayu_bem_gestor/helpers/firebase_errors.dart';

import 'usuario.dart';

class UserManager extends ChangeNotifier {
  UserManager() {
    _loadCurrentUser();
  }

  FlutterInsta flutterInsta = FlutterInsta();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Usuario? usuario;
  bool _loading = false;

  bool get loading => _loading;

  bool get adminEnabled => usuario != null && usuario!.admin;

  bool get isLoggedIn => usuario != null;

  Future<void> signIn({Usuario? user, Function? onFail, Function? onSuccess}) async {
    loading = true;

    try {
      final metodosLogin = await auth.fetchSignInMethodsForEmail(user!.email!);

      if (metodosLogin.isNotEmpty && metodosLogin[0].compareTo('facebook.com') == 0) {
        throw Exception(metodosLogin[0]);
      }

      final UserCredential result =
          await auth.signInWithEmailAndPassword(email: user.email as String, password: user.senha as String);

      await _loadCurrentUser(firebaseUser: result.user);

      if (usuario!.admin) {
        onSuccess!();
      } else {
        onFail!(getErrorString('user_not_admin'));
      }
    } on Exception catch (ex) {
      onFail!(getErrorString(ex.toString()));
    }

    loading = false;
  }

  Future<void> facebookLogin({Function? onFail, Function? onSuccess}) async {
    loading = true;

    final result = await FacebookAuth.instance.login(permissions: [
      'email',
      'public_profile',
      'user_location',
      'user_birthday',
      'user_photos',
      'instagram_content_publish',
    ]);

    switch (result.status) {
      case LoginStatus.success:
        final credential = FacebookAuthProvider.credential(result.accessToken!.token);

        final dadosUsuario = await FacebookAuth.instance.getUserData(fields: "email,location,birthday,photos");

        print(dadosUsuario);

        try {
          final authResult = await auth.signInWithCredential(credential);

          if (authResult.user != null) {
            final firebaseUser = authResult.user;

            usuario = Usuario(uid: firebaseUser!.uid, name: firebaseUser.displayName, email: firebaseUser.email);

            if (await _verificarUsuarioAdmin()) {
              await _loadCurrentUser(firebaseUser: firebaseUser);

              onSuccess!();
            } else {
              onFail!(getErrorString('user_not_admin'));
            }
          }
        } on Exception catch (ex) {
          onFail!(getErrorString(ex.toString()));
        }

        break;
      case LoginStatus.operationInProgress:
        break;
      case LoginStatus.cancelled:
        break;
      case LoginStatus.failed:
        onFail!(result.message);
        loading = false;
        break;
    }

    loading = false;
  }

  Future<void> signUp({Usuario? user, Function? onFail, Function? onSuccess}) async {
    loading = true;

    try {
      final UserCredential result =
          await auth.createUserWithEmailAndPassword(password: user!.senha as String, email: user.email as String);

      user.uid = result.user!.uid;

      await user.saveData();

      user.saveToken();

      usuario = user;

      await firestore.collection('gestores').doc(user.uid).set(getAdminMap(user.uid));

      onSuccess!();
    } on Exception catch (ex) {
      onFail!(getErrorString(ex.toString()));
    }

    loading = false;
  }

  void signOut() {
    auth.signOut();
    usuario = null;
    notifyListeners();
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  Future<void> _loadCurrentUser({User? firebaseUser}) async {
    final currentUser = firebaseUser ?? auth.currentUser;
    if (currentUser != null) {
      final DocumentSnapshot<Map<String, dynamic>> docUser =
          await firestore.collection('usuarios').doc(currentUser.uid).get();
      usuario = Usuario.fromDocument(docUser);
      usuario!.admin = await _verificarUsuarioAdmin();

      usuario!.saveToken();
    }

    notifyListeners();
  }

  Future<bool> _verificarUsuarioAdmin() async {
    final docAdmin = await firestore.collection('gestores').doc(usuario!.uid).get();
    return docAdmin.exists;
  }

  Map<String, dynamic> getAdminMap(uid) {
    return {'usuario': uid};
  }

  Future<void> redefinirSenha({required String email, Function? onSuccess, Function? onFail}) async {
    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) => onSuccess!())
        .onError((error, stackTrace) => onFail!(getErrorString(error.toString())));
  }
}
