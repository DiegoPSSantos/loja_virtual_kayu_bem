import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kayu_bem_gestor/helpers/loading_helper.dart';
import 'package:kayu_bem_gestor/helpers/string_helpers.dart';
import 'package:kayu_bem_gestor/models/product.dart';
import 'package:kayu_bem_gestor/models/product_manager.dart';
import 'package:kayu_bem_gestor/screens/products/components/images_form.dart';
import 'package:provider/provider.dart';

import 'components/category_list.dart';
import 'components/home_widget.dart';
import 'components/tamanhos_form.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({required this.categoria}) {
    produto = Product(categoria: categoria, lancamento: false, oferta: false, novaColecao: false);
  }

  late Product produto;
  final String categoria;
  final GlobalKey<FormState> addFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    void onSuccess() {
      context.read<ProductManager>().update(produto);
      Navigator.of(context).pop();
    }

    return ChangeNotifierProvider.value(
        value: produto,
        child: Consumer<Product>(
            builder: (_, prod, __) => Center(
                    child: Stack(children: [
                  Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(title: Text(StringHelper.TITULO_ADD_PRODUTO.toUpperCase()), centerTitle: true),
                      body: Form(
                          key: addFormKey,
                          child: ListView(children: [
                            ImagesForm(produto),
                            Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                                  TextFormField(
                                    initialValue: produto.nome,
                                    decoration: const InputDecoration(
                                      hintText: 'Titulo',
                                      hintStyle: TextStyle(fontWeight: FontWeight.w600),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Color.fromARGB(255, 99, 111, 164), width: 2)),
                                      errorStyle: TextStyle(color: Colors.redAccent),
                                    ),
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                    validator: (titulo) {
                                      if (titulo!.length < 4) {
                                        return 'Informe um t??tulo';
                                      }
                                      return null;
                                    },
                                    onSaved: (titulo) => produto.nome = titulo,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        const Text('Categoria',
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                        Text(CategoryList.getNomeCategoria(produto.categoria!))
                                      ])),
                                  HomeWidget(produto: produto),
                                  const Padding(
                                      padding: EdgeInsets.only(top: 16, bottom: 6),
                                      child: Text(
                                        'Descri????o',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                      )),
                                  TextFormField(
                                    initialValue: produto.descricao,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                    decoration: InputDecoration(
                                        hintText: 'Descri????o',
                                        errorStyle: const TextStyle(color: Colors.redAccent),
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                                        contentPadding: const EdgeInsets.all(8)),
                                    maxLines: 4,
                                    validator: (descricao) {
                                      if (descricao!.length < 10) {
                                        return 'Descri????o muito curta';
                                      }
                                      return null;
                                    },
                                    onSaved: (descricao) => produto.descricao = descricao,
                                  ),
                                  TamanhosForm(produto),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                      height: 44,
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              onPrimary: Colors.white,
                                              primary: primaryColor,
                                              onSurface: primaryColor.withAlpha(100)),
                                          onPressed: !produto.loading
                                              ? () async {
                                                  if (addFormKey.currentState!.validate()) {
                                                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                    addFormKey.currentState!.save();
                                                    await prod.save(onSuccess);
                                                  }
                                                }
                                              : null,
                                          child: const Text('SALVAR', style: TextStyle(fontSize: 16))))
                                ]))
                          ]))),
                  if (produto.loading)
                    LoadingHelper()
                ]))));
  }
}
