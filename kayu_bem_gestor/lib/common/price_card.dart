import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/models/cart_manager.dart';
import 'package:provider/provider.dart';

class PriceCard extends StatelessWidget {
  const PriceCard(this.buttonText, this.onPressed);

  final String buttonText;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<
        CartManager>(); // utilizado quando vamos fazer rebuild na tela toda
    final precoProdutos = cartManager.precoProdutos;
    final precoEntrega = cartManager.precoEntrega;
    final precoTotal = cartManager.precoTotal;

    return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resumo do pedido',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal'),
                    Text('R\$ ${precoProdutos.toStringAsFixed(2)}')
                  ],
                ),
                const SizedBox(height: 4),
                if (precoEntrega != null)
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Entrega'),
                    Text('R\$ ${precoEntrega.toStringAsFixed(2)}')
                  ],
                ),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Text('R\$ ${precoTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 16))
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                      onPressed: onPressed,
                      style: ElevatedButton.styleFrom(
                          onSurface:
                              Theme.of(context).primaryColor.withAlpha(100),
                          onPrimary: Colors.white,
                          primary: Theme.of(context).primaryColor),
                      child: Text(buttonText)),
                )
              ],
            )));
  }
}
