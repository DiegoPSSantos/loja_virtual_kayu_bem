import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kayu_bem/models/user_manager.dart';
import 'package:provider/provider.dart';

class CustomDrawerHeader extends StatelessWidget {
  const CustomDrawerHeader({required this.tituloMenu});

  final String tituloMenu;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(32, 24, 16, 8),
        height: 180,
        child: Consumer<UserManager>(builder: (_, userManager, __) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(children: <Widget>[
                  Text(
                    tituloMenu,
                    style: const TextStyle(
                        fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                ]),
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Text(
                        userManager.isLoggedIn
                            ? 'Olá, ${userManager.usuario?.name ?? ''}'
                            : 'Bem-vindo',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                      // GestureDectetor é melhor que buttom pq
                      // buttom tem muito espaço em volta
                      onTap: () {
                        if (userManager.isLoggedIn) {
                          userManager.signOut();
                          ZoomDrawer.of(context)!.close();
                        } else {
                          ZoomDrawer.of(context)!.close();
                          Navigator.of(context).pushNamed('/login');
                        }
                      },
                      child: Text(
                        userManager.isLoggedIn
                            ? 'Sair'
                            : 'Entre ou cadastre-se >',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ))
                ])
              ]);
        }));
  }
}
