import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/models/user_manager.dart';
import 'package:provider/provider.dart';

import 'custom_drawer_header.dart';
import 'drawer_tile.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color.fromARGB(255, 232, 203, 192), Colors.white],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter))),
              ListView(
                children: const <Widget>[
                  CustomDrawerHeader(tituloMenu: 'Kayu Bem'),
                  Divider(color: Color.fromARGB(255, 130, 208, 215)),
                  DrawerTile(iconData: Icons.insert_chart_rounded, title: 'Gerencial', page: 0),
                  DrawerTile(iconData: Icons.list, title: 'Produtos', page: 1),
                  DrawerTile(iconData: Icons.list, title: 'Tela Inicial\ndos Clientes', page: 2),
                  DrawerTile(iconData: Icons.people_alt_rounded, title: 'Usuários', page: 3),
                  DrawerTile(iconData: Icons.library_books, title: 'Pedidos', page: 4),
                  DrawerTile(iconData: Icons.settings, title: 'Ajustes', page: 5),
                  Divider(color: Color.fromARGB(255, 130, 208, 215)),
                ],
              ),
            ],
          ),
        ),
      );
}
