import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/models/cart_manager.dart';
import 'package:kayu_bem_gestor/models/endereco.dart';
import 'package:provider/provider.dart';

import 'address_input_field.dart';
import 'cep_input_field.dart';

class AddressCard extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
         padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        child: Consumer<CartManager>(
          builder: (_, cartManager, __) {
            final endereco = cartManager.endereco ?? Endereco();

            return Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Endereço de Entrega',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16
                    ),
                  ),
                  CepInputField(endereco),
                  AddressInputField(endereco)
                ],
              ),
            );
          }
        ),
      )
    );
  }
}
