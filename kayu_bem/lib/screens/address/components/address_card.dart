import 'package:flutter/material.dart';
import 'package:kayu_bem/models/cart_manager.dart';
import 'package:provider/provider.dart';

import 'address_input_field.dart';
import 'cep_input_field.dart';

class AddressCard extends StatelessWidget{

  AddressCard({this.tipo_endereco});

  String? tipo_endereco;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Consumer<CartManager>(builder: (_, cartManager, __) {
              return Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Endereço de ${tipo_endereco!}',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    CepInputField(retirada: 'Retirada' == tipo_endereco ? true : false),
                    AddressInputField(retirada: 'Retirada' == tipo_endereco ? true : false)
                  ],
                ),
              );
            }),
          ))
    ]);
  }
}
