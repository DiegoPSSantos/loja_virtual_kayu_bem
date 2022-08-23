import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/models/item_size.dart';
import 'package:kayu_bem_gestor/models/product.dart';
import 'package:provider/provider.dart';

class SizeWidget extends StatelessWidget {
  const SizeWidget({required this.tamanho});

  final ItemSize tamanho;

  @override
  Widget build(BuildContext context) {
    final produto = context.watch<Product>();
    bool selecionado;
    try {
      selecionado = tamanho == produto.tamanhoSelecionado;
    } catch (ex) {
      selecionado = false;
    }

    Color color;
    if (!tamanho.estoqueDisponivel) {
      color = Colors.red.withAlpha(50);
      } else if (selecionado) {
      color = Theme.of(context).primaryColor;
    } else {
      color = Colors.black45;
    }

    return GestureDetector(
      onTap: () {
        if (tamanho.estoqueDisponivel) {
          produto.tamanhoSelecionado = tamanho;
        }
      },
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: color)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                color: color,
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text(
                  tamanho.nome as String,
                  style: const TextStyle(color: Colors.white),
                )),
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'R\$ ${tamanho.preco!.toStringAsFixed(2)}',
                  style: TextStyle(color: color),
                ))
          ],
        ),
      ),
    );
  }
}
