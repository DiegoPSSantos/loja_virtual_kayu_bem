import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kayu_bem_gestor/helpers/loading_helper.dart';
import 'package:kayu_bem_gestor/helpers/string_helpers.dart';
import 'package:kayu_bem_gestor/models/product.dart';
import 'package:kayu_bem_gestor/models/product_manager.dart';
import 'package:kayu_bem_gestor/screens/products/components/category_drop_down.dart';
import 'package:kayu_bem_gestor/screens/products/components/category_list.dart';
import 'package:kayu_bem_gestor/screens/products/components/home_widget.dart';
import 'package:provider/provider.dart';
import 'components/images_form.dart';
import 'components/tamanhos_form.dart';

class EditProductScreen extends StatelessWidget {
  EditProductScreen(Product p) : produto = p.clone();

  final GlobalKey<FormState> editFormKey = GlobalKey();

  Product produto;

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
                    appBar: AppBar(title: Text(StringHelper.TITULO_EDIT_PRODUTO.toUpperCase()), centerTitle: true),
                    body: Form(
                        key: editFormKey,
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
                                      return 'Informe um título';
                                    }
                                    return null;
                                  },
                                  onSaved: (titulo) => produto.nome = titulo,
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: produto.id != null
                                        ? CategoryDropDown(produto)
                                        : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            const Text('Categoria',
                                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                                            Text(CategoryList.getNomeCategoria(produto.categoria!))
                                          ])),
                                HomeWidget(produto: produto),
                                const Padding(
                                    padding: EdgeInsets.only(top: 16, bottom: 6),
                                    child: Text(
                                      'Descrição',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                                    )),
                                TextFormField(
                                  initialValue: produto.descricao,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                      hintText: 'Descrição',
                                      errorStyle: const TextStyle(color: Colors.redAccent),
                                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                                      focusedErrorBorder:
                                          const OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                                      contentPadding: const EdgeInsets.all(8)),
                                  maxLines: 4,
                                  validator: (descricao) {
                                    if (descricao!.length < 10) {
                                      return 'Descrição muito curta';
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
                                                if (editFormKey.currentState!.validate()) {
                                                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                                                  editFormKey.currentState!.save();
                                                  await prod.edit(onSuccess, context);
                                                }
                                              }
                                            : null,
                                        child: const Text('SALVAR', style: TextStyle(fontSize: 16))))
                              ]))
                        ])),
                  ),
                  if (produto.loading) LoadingHelper()
                ]))));
  }
}
