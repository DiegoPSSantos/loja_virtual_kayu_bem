import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kayu_bem/helpers/clothes_icons.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/product_manager.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatelessWidget {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final productManager = context.watch<ProductManager>();

    return Container(
      color: Colors.white,
        height: 60,
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
                iconColor: Theme.of(context).primaryColor,
                icon: ClothesIcons.blusa_alca,
                text: StringHelper.LABEL_CATEGORIA_1,
              ),
              GButton(
                iconColor: Theme.of(context).primaryColor,
                icon: ClothesIcons.calcas,
                text: StringHelper.LABEL_CATEGORIA_2,
              ),
              GButton(
                iconColor: Theme.of(context).primaryColor,
                icon: ClothesIcons.short01,
                text: StringHelper.LABEL_CATEGORIA_3,
              ),
              GButton(
                iconColor: Theme.of(context).primaryColor,
                icon: ClothesIcons.conjunto_short_blusa,
                text: StringHelper.LABEL_CATEGORIA_4,
              ),
              GButton(
                iconColor: Theme.of(context).primaryColor,
                icon: ClothesIcons.vestido_colado,
                text: StringHelper.LABEL_CATEGORIA_5,
              ),
              GButton(
                iconColor: Theme.of(context).primaryColor,
                icon: ClothesIcons.saia,
                text: StringHelper.LABEL_CATEGORIA_6,
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
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
            },
          )
        ]));
  }
}
