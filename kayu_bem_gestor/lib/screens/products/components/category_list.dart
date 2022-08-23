import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kayu_bem_gestor/helpers/clothes_icons.dart';
import 'package:kayu_bem_gestor/helpers/string_helpers.dart';
import 'package:kayu_bem_gestor/models/product_manager.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatelessWidget {
  late int _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final productManager = context.watch<ProductManager>();
    selectedAbaAtivaInicial(productManager.categoria);

    return Container(
        height: 60,
        color: Colors.white,
        child: ListView(scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
          GNav(
            backgroundColor: Colors.white,
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 6,
            activeColor: Colors.black,
            iconSize: 32,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: [
              GButton(
                active: productManager.categoria == StringHelper.PATH_CATEGORIA_1,
                iconColor: Theme.of(context).primaryColor,
                icon: ClothesIcons.blusa_alca,
                text: StringHelper.LABEL_CATEGORIA_1,
              ),
              GButton(
                active: productManager.categoria == StringHelper.PATH_CATEGORIA_2,
                iconColor: Theme.of(context).primaryColor,
                icon: ClothesIcons.calcas,
                text: StringHelper.LABEL_CATEGORIA_2,
              ),
              GButton(
                active: productManager.categoria == StringHelper.PATH_CATEGORIA_3,
                iconColor: Theme.of(context).primaryColor,
                icon: ClothesIcons.short01,
                text: StringHelper.LABEL_CATEGORIA_3,
              ),
              GButton(
                active: productManager.categoria == StringHelper.PATH_CATEGORIA_4,
                iconColor: Theme.of(context).primaryColor,
                icon: ClothesIcons.conjunto_short_blusa,
                text: StringHelper.LABEL_CATEGORIA_4,
              ),
              GButton(
                active: productManager.categoria == StringHelper.PATH_CATEGORIA_5,
                iconColor: Theme.of(context).primaryColor,
                icon: ClothesIcons.vestido_colado,
                text: StringHelper.LABEL_CATEGORIA_5,
              ),
              GButton(
                active: productManager.categoria == StringHelper.PATH_CATEGORIA_6,
                iconColor: Theme.of(context).primaryColor,
                icon: ClothesIcons.saia,
                text: StringHelper.LABEL_CATEGORIA_6,
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              selectedAba(index, productManager);
            },
          )
        ]));
  }

  void selectedAba(int index, ProductManager productManager) {
    switch (index) {
      case 0: productManager.loadProductsCategory(StringHelper.PATH_CATEGORIA_1);
      break;
      case 1: productManager.loadProductsCategory(StringHelper.PATH_CATEGORIA_2);
      break;
      case 2: productManager.loadProductsCategory(StringHelper.PATH_CATEGORIA_3);
      break;
      case 3: productManager.loadProductsCategory(StringHelper.PATH_CATEGORIA_4);
      break;
      case 4: productManager.loadProductsCategory(StringHelper.PATH_CATEGORIA_5);
      break;
      case 5: productManager.loadProductsCategory(StringHelper.PATH_CATEGORIA_6);
      break;
    }
  }

  void selectedAbaAtivaInicial(String path) {
    switch (path) {
      case StringHelper.PATH_CATEGORIA_1: _selectedIndex = 0;
      break;
      case StringHelper.PATH_CATEGORIA_2: _selectedIndex = 1;
      break;
      case StringHelper.PATH_CATEGORIA_3: _selectedIndex = 2;
      break;
      case StringHelper.PATH_CATEGORIA_4: _selectedIndex = 3;
      break;
      case StringHelper.PATH_CATEGORIA_5: _selectedIndex = 4;
      break;
      case StringHelper.PATH_CATEGORIA_6: _selectedIndex = 5;
      break;
    }
  }

  static String getNomeCategoria(String categoria) {
    String nome = '';
    switch (categoria) {
      case StringHelper.PATH_CATEGORIA_1: nome = StringHelper.LABEL_CATEGORIA_1;
        break;
      case StringHelper.PATH_CATEGORIA_2: nome = StringHelper.LABEL_CATEGORIA_2;
        break;
      case StringHelper.PATH_CATEGORIA_3: nome = StringHelper.LABEL_CATEGORIA_3;
        break;
      case StringHelper.PATH_CATEGORIA_4: nome = StringHelper.LABEL_CATEGORIA_4;
        break;
      case StringHelper.PATH_CATEGORIA_5: nome = StringHelper.LABEL_CATEGORIA_5;
        break;
      case StringHelper.PATH_CATEGORIA_6: nome = StringHelper.LABEL_CATEGORIA_6;
        break;
      default: return nome;
    }
    return nome;
  }
}
