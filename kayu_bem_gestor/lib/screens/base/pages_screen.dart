import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/models/page_manager.dart';
import 'package:kayu_bem_gestor/models/user_manager.dart';
import 'package:kayu_bem_gestor/screens/analises/dashboard_screen.dart';
import 'package:kayu_bem_gestor/screens/configuracao/ajustes_screen.dart';
import 'package:kayu_bem_gestor/screens/home/home_screen.dart';
import 'package:kayu_bem_gestor/screens/pedidos/all_pedidos_screen.dart';
import 'package:kayu_bem_gestor/screens/products/products_screen.dart';
import 'package:kayu_bem_gestor/screens/usuarios/usuarios_screen.dart';
import 'package:provider/provider.dart';

class PagesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<UserManager>(
      builder: (_, userManager, __) => PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: context.read<PageManager>().pageController,
            children: [
              DashboardScreen(),
              ProductsScreen(),
              HomeScreen(),
              UsuariosScreen(),
              AllPedidosScreen(),
              AjustesScreen()
            ],
          ));
}
