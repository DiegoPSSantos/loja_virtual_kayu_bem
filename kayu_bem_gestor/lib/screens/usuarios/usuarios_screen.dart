import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kayu_bem_gestor/models/page_manager.dart';
import 'package:kayu_bem_gestor/models/pedido_manager.dart';
import 'package:kayu_bem_gestor/models/users_manager.dart';
import 'package:provider/provider.dart';

class UsuariosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: InkWell(onTap: () => ZoomDrawer.of(context)!.toggle(), child: const Icon(Icons.menu)),
          title: const Text('USUÁRIOS'),
          centerTitle: true,
        ),
        body: Consumer<UsersManager>(
          builder: (_, usersManager, __) => Column(children: [
            Expanded(
                child: AlphabetScrollView(
              itemBuilder: (_, index, id) => ListTile(
                title: Text(
                  usersManager.usuarios[index].name!,
                  style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white, fontSize: 20),
                ),
                subtitle: Text(
                  usersManager.usuarios[index].email!,
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  context.read<PedidoManager>().setUsuarioFilter(usersManager.usuarios[index]);
                  context.read<PageManager>().setPage(3);
                },
              ),
              list: usersManager.names,
              itemExtent: 90,
              selectedTextStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 24, color: Colors.white),
              unselectedTextStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18, color: Colors.white),
              overlayWidget: (value) => Container(
                height: 50,
                width: 50,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  value.toUpperCase(),
                  style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
                ),
              ),
            ))
          ]),
        ),
      );
}
