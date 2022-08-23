import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kayu_bem/common/empty_card.dart';
import 'package:kayu_bem/common/login_card.dart';
import 'package:kayu_bem/models/pedido_manager.dart';
import 'package:provider/provider.dart';

import 'components/pedido_tile.dart';

class PedidosScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MEUS PEDIDOS'),
        centerTitle: true,
        leading: InkWell(
            onTap: () => ZoomDrawer.of(context)!.toggle(),
            child: const Icon(Icons.menu)),
      ),
      body: Consumer<PedidoManager>(
        builder: (_, pedidoManager, __) {
          if (pedidoManager.usuario == null) {
            return LoginCard();
          }
          if (pedidoManager.pedidos.isEmpty) {
            return const EmptyCard(
                titulo: 'Nenhuma compra encontrada!',
                iconData: Icons.border_clear);
          }
          return ListView.builder(
              itemCount: pedidoManager.pedidos.length,
              itemBuilder: (_, index) =>
                  PedidoTile(pedidoManager.pedidos.reversed.toList()[index]));
        },
      ),
    );
  }
}
