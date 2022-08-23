import 'package:flutter/material.dart';
import 'package:kayu_bem/models/pedido.dart';

import 'pedido_item_tile.dart';

class PedidoTile extends StatelessWidget {

  const PedidoTile(this.pedido);

  final Pedido pedido;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    pedido.idFormatado,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: primaryColor
                    ),
                ),
                Text(
                  'R\$ ${pedido.preco.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 14
                  ),
                ),
                Text(
                  pedido.dataHoraToString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                      fontSize: 14
                  ),
                )
              ],
            ),
            SizedBox(width: 150, child: Text(
              pedido.statusText,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                color: primaryColor,
                fontSize: 14
              ),
            ))
          ],
        ),
        children: [
          Column(
            children: pedido.items.map((item) => PedidoItemTile(item)).toList(),
          )
        ],
      ),
    );
  }
}
