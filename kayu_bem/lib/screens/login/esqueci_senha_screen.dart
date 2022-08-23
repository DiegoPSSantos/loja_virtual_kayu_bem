import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayu_bem/helpers/validators.dart';
import 'package:kayu_bem/models/user_manager.dart';
import 'package:provider/provider.dart';

class EsqueciSenhaScreen extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();

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
                      margin: const EdgeInsets.only(right: 16, left: 16),
                      child: Stack(children: [
                        Container(
                            height: 470,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color.fromRGBO(120, 152, 177, .9))),
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
                                Center(child: Image.asset('assets/images/esqueci_minha_senha.png', height: 160)),
                                const Center(
                                    child: Text('Esqueceu a senha?',
                                        style:
                                            TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
                                Container(
                                    margin: const EdgeInsets.only(top: 8),
                                    child: const Text(
                                        'Informe seu e-mail cadastrado para que possamos enviar um link para redefinição de senha',
                                        style: TextStyle(color: Colors.white))),
                                const SizedBox(height: 16),
                                TextFormField(
                                  style: const TextStyle(color: Color.fromARGB(255, 99, 111, 164)),
                                  decoration: const InputDecoration(
                                      prefixIconConstraints: BoxConstraints(maxHeight: 20),
                                      filled: true,
                                      fillColor: Color(0xB3ffffff),
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
                                      return 'E-mail inválido!!!';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                SizedBox(
                                    height: 44,
                                    child: ElevatedButton(
                                        onPressed: userManager.loading
                                            ? null
                                            : () async {
                                                if (formKey.currentState!.validate()) {
                                                  await userManager.redefinirSenha(
                                                      email: emailController.text,
                                                      onSuccess: () => AwesomeDialog(
                                                          context: context,
                                                          dialogType: DialogType.SUCCES,
                                                          title: 'E-MAIL ENVIADO COM SUCESSO',
                                                          desc:
                                                              'Favor verificar na sua caixa de entrada, caso não encontre também verifique na caixa de spam.',
                                                          btnOkColor: Theme.of(context).primaryColor,
                                                          btnOkOnPress: () => Navigator.pop(context))
                                                        ..show(),
                                                      onFail: (erro) async => AwesomeDialog(
                                                          context: context,
                                                          dialogType: DialogType.ERROR,
                                                          title: 'E-MAIL NÃO ENVIADO',
                                                          desc: erro.toString(),
                                                          btnOkColor: Theme.of(context).primaryColor,
                                                          btnOkOnPress: () {})
                                                        ..show());
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                            primary: userManager.loading
                                                ? Theme.of(context).primaryColor.withAlpha(100)
                                                : Theme.of(context).primaryColor),
                                        child: const Text('ENVIAR',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)))),
                              ]),
                        )
                      ])),
                  if (userManager.loading)
                    Container(
                        color: Colors.grey.withOpacity(0.8),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)))
                ]),
              );
            },
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Esqueci minha senha',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ]));
  }
}
