import 'package:flutter/material.dart';
import 'package:kayu_bem/common/custom_drawer/custom_drawer_header.dart';
import 'package:kayu_bem/common/custom_drawer/drawer_tile.dart';

class MenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                Color.fromARGB(255, 232, 203, 192),
                Colors.white
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
              ListView(
                children: const <Widget>[
                  CustomDrawerHeader(tituloMenu: 'Kayu Bem'),
                  Divider(color: Color.fromARGB(255, 130, 208, 215)),
                  DrawerTile(iconData: Icons.home, title: 'Início', page: 0),
                  DrawerTile(iconData: Icons.list, title: 'Produtos', page: 1),
                  DrawerTile(
                      iconData: Icons.playlist_add_check,
                      title: 'Meus Pedidos',
                      page: 2),
                  // DrawerTile(
                  //     iconData: Icons.location_on, title: 'Lojas', page: 3),
                ],
              ),
            ],
          ),
        ),
      );
}
