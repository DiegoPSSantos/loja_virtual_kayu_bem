import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/helpers/clothes_icons.dart';
import 'package:kayu_bem_gestor/helpers/string_helpers.dart';
import 'package:kayu_bem_gestor/models/product.dart';
import 'package:kayu_bem_gestor/screens/products/components/category_item.dart';

class CategoryDropDown extends StatefulWidget {
  CategoryDropDown(this.produto);

  Product produto;

  @override
  _CategoryDropDownState createState() => _CategoryDropDownState();
}

class _CategoryDropDownState extends State<CategoryDropDown> {
  List<CategoryItem> items = [
    CategoryItem(
        icone: ClothesIcons.blusa_alca, descricao: StringHelper.LABEL_CATEGORIA_1, path: StringHelper.PATH_CATEGORIA_1),
    CategoryItem(
        icone: ClothesIcons.calcas, descricao: StringHelper.LABEL_CATEGORIA_2, path: StringHelper.PATH_CATEGORIA_2),
    CategoryItem(
        icone: ClothesIcons.conjunto_short_blusa,
        descricao: StringHelper.LABEL_CATEGORIA_3,
        path: StringHelper.PATH_CATEGORIA_3),
    CategoryItem(
        icone: ClothesIcons.short01, descricao: StringHelper.LABEL_CATEGORIA_4, path: StringHelper.PATH_CATEGORIA_4),
    CategoryItem(
        icone: ClothesIcons.vestido, descricao: StringHelper.LABEL_CATEGORIA_5, path: StringHelper.PATH_CATEGORIA_5),
    CategoryItem(
        icone: ClothesIcons.saia, descricao: StringHelper.LABEL_CATEGORIA_6, path: StringHelper.PATH_CATEGORIA_6)
  ];

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return DropdownButtonFormField(
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        ),
        hint: const Text('Selecione uma categoria'),
        value: widget.produto.categoria,
        validator: (String? item) {
          if (item == null) {
            return 'Informe a categoria';
          }
          return null;
        },
        onChanged: (path) {
          setState(() {
            widget.produto.novaCategoria = path! as String;
          });
        },
        onSaved: (path) {
          widget.produto.novaCategoria = path! as String;
        },
        selectedItemBuilder: (BuildContext context) {
          return items.map<Widget>((item) {
            return Row(children: [
              Text(item.descricao, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 8),
              Icon(item.icone)
            ]);
          }).toList()
            ..insert(
                0,
                (const DropdownMenuItem(
                    value: '',
                    child: Text(
                      'Selecione uma categoria',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ))));
        },
        items: items.map((item) => DropdownMenuItem<String>(value: item.path, child: item)).toList()
          ..insert(
              0,
              (const DropdownMenuItem(
                  value: '',
                  child: Text(
                    'Selecione uma categoria',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )))));
  }
}
