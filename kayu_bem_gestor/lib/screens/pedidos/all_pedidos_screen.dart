import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kayu_bem_gestor/common/custom_icon_button.dart';
import 'package:kayu_bem_gestor/common/empty_card.dart';
import 'package:kayu_bem_gestor/models/pedido.dart';
import 'package:kayu_bem_gestor/models/pedido_manager.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'components/pedido_tile.dart';

class AllPedidosScreen extends StatelessWidget {
  final PanelController panelController = PanelController();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PEDIDOS'),
        centerTitle: true,
        leading: InkWell(onTap: () => ZoomDrawer.of(context)!.toggle(), child: const Icon(Icons.menu)),
      ),
      body: Consumer<PedidoManager>(
        builder: (_, pedidoManager, __) {
          final pedidoFiltrados = pedidoManager.pedidosFiltrados;
          const radius = BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          );

          return SlidingUpPanel(
            controller: panelController,
            collapsed: Container(
              child: GestureDetector(
                onTap: () {
                  if (panelController.isPanelClosed) {
                    panelController.open();
                  } else {
                    panelController.close();
                  }
                },
                child: Container(
                  decoration: const BoxDecoration(borderRadius: radius, color: Colors.white),
                  alignment: Alignment.center,
                  height: 40,
                  child: Text('FILTROS',
                      style: TextStyle(color: primaryColor, fontWeight: FontWeight.w800, fontSize: 16)),
                ),
              ),
            ),
            body: Column(children: [
              if (pedidoManager.usuarioFilter != null)
                Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 2),
                    child: Row(children: [
                      Expanded(
                          child: Text('Pedidos de ${pedidoManager.usuarioFilter!.name}',
                              style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white))),
                      CustomIconButton(
                          iconData: Icons.close, color: Colors.white, onTap: () => pedidoManager.setUsuarioFilter(null))
                    ])),
              if (pedidoFiltrados.isEmpty)
                const Expanded(child: EmptyCard(titulo: 'Nenhuma venda realizada!', iconData: Icons.border_clear))
              else
                Expanded(
                  child: ListView.builder(
                      itemCount: pedidoFiltrados.length, itemBuilder: (_, index) => PedidoTile(pedidoFiltrados[index])),
                ),
              const SizedBox(height: 45)
            ]),
            borderRadius: radius,
            minHeight: 40,
            maxHeight: 240,
            panel: Column(children: [
              GestureDetector(
                onTap: () {
                  if (panelController.isPanelClosed) {
                    panelController.open();
                  } else {
                    panelController.close();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(borderRadius: radius, color: primaryColor),
                  alignment: Alignment.center,
                  height: 40,
                  child: const Text('FILTROS',
                      style:
                          TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                ),
              ),
              Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: Status.values
                          .map((s) => CheckboxListTile(
                              title: Text(Pedido.getStatusText(s),
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                              activeColor: primaryColor,
                              value: pedidoManager.statusFilter.contains(s),
                              dense: true,
                              onChanged: (v) => pedidoManager.setStatusFilter(status: s, enabled: v!)))
                          .toList()))
            ]),
          );
        },
      ),
    );
  }
}
