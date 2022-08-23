import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayu_bem/helpers/loading_helper.dart';
import 'package:kayu_bem/helpers/validators.dart';
import 'package:kayu_bem/models/user_manager.dart';
import 'package:kayu_bem/models/usuario.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'esqueci_senha_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController senhaController = TextEditingController();

  double alturaCard = 440;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Stack(children: [
      Consumer<UserManager>(
        builder: (_, userManager, child) {
          // child representa um filho (widget) que é constante e não
          // precisa ser reconstruído quando a tela for refeita.
          // No caso o child é o botão de entrar
          return Center(
            child: Stack(children: [
              Card(
                  elevation: 16,
                  color: Colors.transparent,
                  margin: const EdgeInsets.only(right: 16, left: 16, bottom: 40),
                  child: Stack(children: [
                    Container(
                        height: alturaCard,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: const Color(0xff7c94b6),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.2), BlendMode.dstATop),
                                image: const AssetImage('assets/images/login_bg.png')))),
                    Form(
                      key: formKey,
                      child: ListView(
                          // caso a tela do usuário seja pequena o listview permitirá
                          // o deslizamento do Card para cima.
                          padding: const EdgeInsets.all(16),
                          shrinkWrap: true,
                          // shrinkWrap igual a true defini o menor tamanho possível para tela, sem isso
                          // o padrão é ocupar totalmente o tamanho disponível da tela
                          children: <Widget>[
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Expanded(
                                  child: Container(
                                      child: Text('Kayu Bem',
                                          style: GoogleFonts.raleway(
                                              fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
                                          textAlign: TextAlign.center))),
                            ]),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                  prefixIconConstraints: BoxConstraints(maxHeight: 20),
                                  filled: true,
                                  fillColor: Color.fromARGB(50, 255, 255, 255),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromARGB(255, 99, 111, 164)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromARGB(255, 99, 111, 164), width: 2),
                                  ),
                                  hintText: 'E-mail',
                                  hintStyle: TextStyle(color: Color.fromARGB(255, 99, 111, 164)),
                                  prefixIcon: Padding(
                                      padding: EdgeInsets.only(left: 5, right: 16),
                                      child: Icon(Icons.account_circle, color: Color.fromARGB(255, 99, 111, 164)))),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              enabled: !userManager.loading,
                              controller: emailController,
                              validator: (email) {
                                if (!emailValid(email!)) {
                                  setState(() => alturaCard = 485);
                                  return 'E-mail inválido!!!';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              decoration: const InputDecoration(
                                  prefixIconConstraints: BoxConstraints(maxHeight: 20),
                                  hintText: 'Senha',
                                  hintStyle: TextStyle(color: Color.fromARGB(255, 99, 111, 164)),
                                  filled: true,
                                  fillColor: Color.fromARGB(50, 255, 255, 255),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromARGB(255, 99, 111, 164)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Color.fromARGB(255, 99, 111, 164), width: 2),
                                  ),
                                  prefixIcon: Padding(
                                      padding: EdgeInsets.only(left: 5, right: 16),
                                      child: Icon(Icons.lock, color: Color.fromARGB(255, 99, 111, 164)))),
                              autocorrect: false,
                              obscureText: true,
                              enabled: !userManager.loading,
                              controller: senhaController,
                              validator: (senha) {
                                if (senha!.isEmpty || senha.length < 6) {
                                  setState(() => alturaCard = 485);
                                  return 'Senha Inválida';
                                }
                                return null;
                              },
                            ),
                            Align(alignment: Alignment.centerRight, child: child),
                            const SizedBox(height: 16),
                            SizedBox(
                                height: 44,
                                child: ElevatedButton(
                                    onPressed: userManager.loading
                                        ? null
                                        : () {
                                            if (formKey.currentState!.validate()) {
                                              userManager.signIn(
                                                  user: Usuario(
                                                    email: emailController.text,
                                                    senha: senhaController.text,
                                                  ),
                                                  onFail: (String error) {
                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                        content: Text(error.toUpperCase(),
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            )),
                                                        backgroundColor: Colors.red));
                                                  },
                                                  onSuccess: () {
                                                    Navigator.of(context).pop();
                                                  });
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                        primary: userManager.loading
                                            ? Theme.of(context).primaryColor.withAlpha(100)
                                            : Theme.of(context).primaryColor),
                                    child: const Text('LOGIN',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))),
                            const SizedBox(height: 8),
                            SignInButton(Buttons.FacebookNew,
                                padding: const EdgeInsets.all(10),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                text: 'ENTRAR COM FACEBOOK',
                                onPressed: () => userManager.facebookLogin(onFail: (String error) {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(error.toUpperCase(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              )),
                                          backgroundColor: Colors.red));
                                    }, onSuccess: () {
                                      Navigator.of(context).pop();
                                    })),
                            const Padding(
                              padding: EdgeInsets.only(top: 12, bottom: 8),
                              child: Text(
                                'OU',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                            SizedBox(
                                height: 44,
                                child: ElevatedButton(
                                    onPressed: () => Navigator.of(context).pushReplacementNamed('/signup'),
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                      primary: Theme.of(context).primaryColor,
                                    ),
                                    child: const Text('CRIAR CONTA',
                                        style:
                                            TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold))))
                          ]),
                    )
                  ])),
              if (userManager.loading) LoadingHelper()
            ]),
          );
        },
        child: TextButton(
          onPressed: () => Navigator.push(
              context,
              PageTransition(
                  child: EsqueciSenhaScreen(),
                  type: PageTransitionType.scale,
                  alignment: Alignment.center)),
          child: const Text(
            'Esqueci minha senha',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      )
    ]));
  }
}
