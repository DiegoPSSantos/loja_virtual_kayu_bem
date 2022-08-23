import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/models/pedido.dart';
import 'package:kayu_bem_gestor/screens/pedidos/components/pedido_item_tile.dart';

class ConfirmacaoScreen extends StatelessWidget {
  const ConfirmacaoScreen(this.pedido);

  final Pedido pedido;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PEDIDO CONFIRMADO'),
        centerTitle: true,
      ),
      body: Center(
          child: Card(
        margin: const EdgeInsets.all(16),
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pedido.idFormatado,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor),
                  ),
                  Text(
                    'R\$ ${pedido.preco.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14),
                  )
                ],
              ),
            ),
            Column(
              children:
                  pedido.items.map((item) => PedidoItemTile(item)).toList(),
            )
          ],
        ),
      )),
    );
  }
}
