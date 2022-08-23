import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kayu_bem_gestor/helpers/validators.dart';
import 'package:kayu_bem_gestor/models/user_manager.dart';
import 'package:kayu_bem_gestor/models/usuario.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey();

  final Usuario user = Usuario();

  bool ocultaSenha = true;
  double alturaCard = 420;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Consumer<UserManager>(
            builder: (_, userManager, __) => Center(
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
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shrinkWrap: true,
                              children: <Widget>[
                                Stack(alignment: Alignment.center, children: [
                                  Text('Kayu Bem',
                                      style: GoogleFonts.raleway(
                                          fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white),
                                      textAlign: TextAlign.center),
                                  Padding(padding: const EdgeInsets.only(top: 40), child: Text('Gestor',
                                      style: GoogleFonts.greatVibes(
                                          fontSize: 26, fontWeight: FontWeight.w700, color: Colors.black))),
                                ]),
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
                                      hintText: 'Nome Completo',
                                      hintStyle: TextStyle(color: Color.fromARGB(255, 99, 111, 164))),
                                  enabled: !userManager.loading,
                                  validator: (name) {
                                    if (name!.isEmpty) {
                                      setState(() => alturaCard = 500);
                                      return 'Campo obrigatório';
                                    } else if (!name.trim().contains(' ')) {
                                      return 'Nome completo deve ser informado';
                                    }
                                    return null;
                                  },
                                  onSaved: (name) => user.name = name,
                                ),
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
                                        hintStyle: TextStyle(color: Color.fromARGB(255, 99, 111, 164))),
                                    enabled: !userManager.loading,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (email) {
                                      if (email!.isEmpty) {
                                        setState(() => alturaCard = 500);
                                        return 'Campo obrigatório';
                                      } else if (!emailValid(email)) {
                                        return 'E-mail inválido';
                                      }
                                      return null;
                                    },
                                    onSaved: (email) => user.email = email),
                                const SizedBox(height: 16),
                                TextFormField(
                                  style: const TextStyle(color: Color.fromARGB(255, 99, 111, 164)),
                                  decoration: InputDecoration(
                                      suffixIconConstraints: const BoxConstraints(maxHeight: 40),
                                      hintText: 'Senha',
                                      hintStyle: const TextStyle(color: Color.fromARGB(255, 99, 111, 164)),
                                      filled: true,
                                      fillColor: Color(0xB3ffffff),
                                      enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Color.fromARGB(255, 99, 111, 164)),
                                      ),
                                      focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(color: Color.fromARGB(255, 99, 111, 164), width: 2),
                                      ),
                                      suffixIcon: IconButton(
                                          icon: const Icon(Icons.remove_red_eye),
                                          color: ocultaSenha ? const Color.fromARGB(255, 99, 111, 164) : Colors.white,
                                          onPressed: () => setState(() => ocultaSenha = !ocultaSenha))),
                                  enabled: !userManager.loading,
                                  obscureText: ocultaSenha,
                                  validator: (senha) {
                                    if (senha!.isEmpty) {
                                      setState(() => alturaCard = 500);
                                      return 'Campo obrigatório';
                                    } else if (senha.length < 6) {
                                      return 'Senha muito curta';
                                    }
                                    return null;
                                  },
                                  onSaved: (senha) => user.senha = senha,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  style: const TextStyle(color: Color.fromARGB(255, 99, 111, 164)),
                                  decoration: const InputDecoration(
                                      prefixIconConstraints: BoxConstraints(maxHeight: 20),
                                      hintText: 'Repita a Senha',
                                      hintStyle: TextStyle(color: Color.fromARGB(255, 99, 111, 164)),
                                      filled: true,
                                      fillColor: Color(0xB3ffffff),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Color.fromARGB(255, 99, 111, 164)),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(color: Color.fromARGB(255, 99, 111, 164), width: 2),
                                      ),
                                  ),
                                  enabled: !userManager.loading,
                                  obscureText: ocultaSenha,
                                  validator: (senha) {
                                    if (senha!.isEmpty) {
                                      setState(() => alturaCard = 500);
                                      return 'Campo obrigatório';
                                    } else if (senha.length < 6) {
                                      return 'Senha muito curta';
                                    }
                                    return null;
                                  },
                                  onSaved: (senha) => user.confirmarSenha = senha,
                                ),
                                const SizedBox(height: 32),
                                SizedBox(
                                    height: 44,
                                    child: ElevatedButton(
                                        onPressed: userManager.loading
                                            ? null
                                            : () {
                                                if (formKey.currentState!.validate()) {
                                                  formKey.currentState!.save();

                                                  if (user.senha != user.confirmarSenha) {
                                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                                        content: Text('SENHAS NÃO COINCIDEM!',
                                                            style: TextStyle(
                                                              fontWeight: FontWeight.bold,
                                                            )),
                                                        backgroundColor: Colors.red));
                                                    return;
                                                  }

                                                  userManager.signUp(
                                                      user: user,
                                                      onSuccess: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      onFail: (String error) {
                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                            content: Text(error.toUpperCase(),
                                                                style: const TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                )),
                                                            backgroundColor: Colors.red));
                                                      });
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                          primary: Theme.of(context).primaryColor,
                                        ),
                                        child: const Text('CRIAR',
                                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))))
                              ],
                            ))
                      ])),
                  if (userManager.loading)
                    Container(
                        color: Colors.grey.withOpacity(0.8),
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor)))
                ]))));
  }
}
