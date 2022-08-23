import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/common/custom_icon_button.dart';
import 'package:kayu_bem_gestor/models/item_size.dart';

class EditItemSize extends StatelessWidget {
  EditItemSize(
      {required Key key,
      required this.tamanho,
      required this.onRemove,
      required this.onMoveUp,
      required this.onMoveDown})
      : super(key: key);

  final ItemSize tamanho;
  final VoidCallback onRemove;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(children: [
      Row(
        children: <Widget>[
          Expanded(
              flex: 30,
              child: TextFormField(
                  initialValue: tamanho.nome,
                  validator: (titulo) {
                    if (titulo!.isEmpty) {
                      return 'Inválido';
                    }
                    return null;
                  },
                  onChanged: (titulo) => tamanho.nome = titulo,
                  decoration: const InputDecoration(
                      labelText: 'Título',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 99, 111, 164)),
                      isDense: true,
                      focusColor: Color.fromARGB(255, 99, 111, 164),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 99, 111, 164), width: 2))))),
          const SizedBox(width: 4),
          Expanded(
              flex: 30,
              child: TextFormField(
                initialValue: tamanho.estoque?.toString(),
                validator: (estoque) {
                  if (int.tryParse(estoque!) == null) {
                    return 'Inválido';
                  }
                  return null;
                },
                onChanged: (estoque) => tamanho.estoque = int.tryParse(estoque),
                decoration: const InputDecoration(
                    labelText: 'Estoque',
                    isDense: true,
                    labelStyle: TextStyle(color: Color.fromARGB(255, 99, 111, 164)),
                    focusColor: Color.fromARGB(255, 99, 111, 164),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(255, 99, 111, 164), width: 2))),
                keyboardType: TextInputType.number,
              )),
          const SizedBox(width: 4),
          Expanded(
              flex: 40,
              child: TextFormField(
                  initialValue: tamanho.preco?.toStringAsFixed(2),
                  validator: (preco) {
                    if (num.tryParse(preco!) == null) {
                      return 'Inválido';
                    }
                    return null;
                  },
                  onChanged: (preco) => tamanho.preco = num.tryParse(preco),
                  decoration: const InputDecoration(
                      labelText: 'Preço',
                      isDense: true,
                      prefixText: 'R\$ ',
                      labelStyle: TextStyle(color: Color.fromARGB(255, 99, 111, 164)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 99, 111, 164), width: 2))),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true))),
          CustomIconButton(iconData: Icons.remove, color: Colors.red, onTap: onRemove),
          CustomIconButton(
            iconData: Icons.arrow_drop_up,
            color: Colors.black,
            onTap: onMoveUp,
          ),
          CustomIconButton(
            iconData: Icons.arrow_drop_down,
            color: Colors.black,
            onTap: onMoveDown,
          ),
        ],
      )
    ]));
  }
}
