import 'package:flutter/material.dart';
import 'package:kayu_bem/models/page_manager.dart';
import 'package:kayu_bem/screens/cart/cart_screen.dart';
import 'package:kayu_bem/screens/home/home_screen.dart';
import 'package:kayu_bem/screens/pedidos/pedidos_screen.dart';
import 'package:kayu_bem/screens/products/products_screen.dart';
import 'package:provider/provider.dart';

class PagesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) => PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: context.read<PageManager>().pageController,
      children: [
        HomeScreen(),
        ProductsScreen(),
        PedidosScreen()
      ],
    );
}
