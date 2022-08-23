import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/helpers/string_helpers.dart';
import 'package:kayu_bem_gestor/models/product.dart';

class HomeWidget extends StatefulWidget {
  HomeWidget({required this.produto});

  Product produto;

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    Product p = widget.produto;
    var primaryColor = Theme.of(context).primaryColor;

    return Column(children: [
      const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 6),
          child: Text(
            StringHelper.TXT_PROD_TELA_INCIAL,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          )),
      CheckboxListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          activeColor: primaryColor,
          title: const Text(StringHelper.LABEL_LANCAMENTO),
          value: p.lancamento,
          onChanged: (value) => setState(() {
                p.lancamento = value;
              })),
      CheckboxListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          activeColor: primaryColor,
          title: const Text(StringHelper.LABEL_OFERTA),
          value: p.oferta,
          onChanged: (value) => setState(() {
                p.oferta = value;
              })),
      CheckboxListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          activeColor: primaryColor,
          title: const Text(StringHelper.LABEL_NOVA_COLECAO),
          value: p.novaColecao,
          onChanged: (value) => setState(() {
                p.novaColecao = value;
              }))
    ]);
  }
}
