import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/common/custom_icon_button.dart';
import 'package:kayu_bem_gestor/models/item_size.dart';
import 'package:kayu_bem_gestor/models/product.dart';

import 'edit_item_size.dart';

class TamanhosForm extends StatelessWidget {
  const TamanhosForm(this.produto);

  final Product produto;

  @override
  Widget build(BuildContext context) {
    return FormField<List<ItemSize>>(
      initialValue: produto.tamanhos,
      validator: (tamanhos) {
        if (tamanhos!.isEmpty) {
          return 'Insira um tamanho';
        }
        return null;
      },
      builder: (state) {
        return Column(
          children: [
            const SizedBox(height: 8),
            Row(children: [
              const Expanded(child: Text('Tamanhos', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))),
              CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: () {
                    state.value!.add(ItemSize());
                    state.didChange(state.value);
                  })
            ]),
            Column(
              children: state.value!.map((tamanho) {
                return Row(
                  children: [
                    EditItemSize(
                      key: ObjectKey(tamanho),
                        tamanho: tamanho,
                        onRemove: () {
                          state.value!.remove(tamanho);
                          state.didChange(state.value);
                        },
                      onMoveUp: tamanho != state.value!.first ? () {
                        final index = state.value!.indexOf(tamanho);
                        state.value!.remove(tamanho);
                        state.value!.insert(index - 1, tamanho);
                        state.didChange(state.value);
                      } : null,
                      onMoveDown: tamanho != state.value!.last ? () {
                        final index = state.value!.indexOf(tamanho);
                        state.value!.remove(tamanho);
                        state.value!.insert(index + 1, tamanho);
                        state.didChange(state.value);
                      } : null,
                    )
                  ],
                );
              }).toList(),
            ),
            if (state.hasError)
              Container(
                  margin: const EdgeInsets.only(top: 16, left: 16),
                  alignment: Alignment.centerLeft,
                  child: Text(state.errorText!,
                      style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold)))
          ],
        );
      },
    );
  }
}
