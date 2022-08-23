import 'package:flutter/material.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/cart_manager.dart';
import 'package:provider/provider.dart';

class PriceCard extends StatelessWidget {
  PriceCard(this.buttonText, this.onPressed, {this.marginVertical = 8, this. marginHorizontal = 8});

  final String buttonText;
  final VoidCallback? onPressed;
  double marginVertical;
  double marginHorizontal;

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<
        CartManager>(); // utilizado quando vamos fazer rebuild na tela toda
    final precoProdutos = cartManager.precoProdutos;
    final precoEntrega = cartManager.precoEntrega;
    final precoTotal = cartManager.precoTotal;

    return Card(
        margin: EdgeInsets.symmetric(vertical: marginVertical, horizontal: marginHorizontal),
        elevation: 6,
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
                    Text('R\$ ${StringHelper.getValorMonetario(precoProdutos.toString())}')
                  ],
                ),
                const SizedBox(height: 4),
                if (precoEntrega != null)
                  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Entrega'),
                    Text('R\$ ${StringHelper.getValorMonetario(precoEntrega.toString())}')
                  ],
                ),
                const Divider(),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    Text('R\$ ${StringHelper.getValorMonetario(precoTotal.toString())}',
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
