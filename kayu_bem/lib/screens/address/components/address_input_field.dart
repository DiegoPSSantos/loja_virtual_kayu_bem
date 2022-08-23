import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kayu_bem/models/cart_manager.dart';
import 'package:kayu_bem/models/endereco.dart';
import 'package:provider/provider.dart';

class AddressInputField extends StatelessWidget {
  AddressInputField({this.retirada = false});

  bool retirada;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final cartManager = context.watch<CartManager>();

    if (cartManager.endereco != null && cartManager.endereco!.cep != null && cartManager.precoEntrega == null && !retirada) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: cartManager.endereco!.rua,
            enabled: !cartManager.loading,
            decoration: const InputDecoration(
                isDense: true,
                labelText: 'Rua/Avenida',
                hintText: 'Av. Brasil'),
            validator: (text) => text!.isEmpty ? 'Campo Obrigatório' : null,
            onSaved: (t) => cartManager.endereco!.rua = t,
          ),
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                initialValue: cartManager.endereco!.numero,
                enabled: !cartManager.loading,
                decoration: const InputDecoration(
                    isDense: true, labelText: 'Número', hintText: '123'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                validator: (text) => text!.isEmpty ? 'Campo Obrigatório' : null,
                onSaved: (t) => cartManager.endereco!.numero = t,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: TextFormField(
                initialValue: cartManager.endereco!.complemento,
                enabled: !cartManager.loading,
                decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Complemento',
                    hintText: 'Opcional'),
                onSaved: (t) => cartManager.endereco!.complemento = t,
              ))
            ],
          ),
          TextFormField(
            initialValue: cartManager.endereco!.bairro,
            enabled: !cartManager.loading,
            decoration: const InputDecoration(
                isDense: true, labelText: 'Bairro', hintText: 'Águas Claras'),
            validator: (text) => text!.isEmpty ? 'Campo Obrigatório' : null,
            onSaved: (t) => cartManager.endereco!.bairro = t,
          ),
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: TextFormField(
                    enabled: false,
                    initialValue: cartManager.endereco!.cidade,
                    decoration: const InputDecoration(
                        isDense: true,
                        labelText: 'Cidade',
                        hintText: 'Brasília'),
                    validator: (text) =>
                        text!.isEmpty ? 'Campo Obrigatório' : null,
                    onSaved: (t) => cartManager.endereco!.cidade = t,
                  )),
              const SizedBox(width: 16),
              Expanded(
                  child: TextFormField(
                autocorrect: false,
                enabled: false,
                textCapitalization: TextCapitalization.characters,
                initialValue: cartManager.endereco!.uf,
                decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'UF',
                    hintText: 'DF',
                    counterText: ''),
                maxLength: 2,
                validator: (text) {
                  if (text!.isEmpty) {
                    return 'Campo Obrigatório';
                  } else if (text.length != 2) {
                    return 'Inválido';
                  }
                  return null;
                },
                onSaved: (t) => cartManager.endereco!.uf = t,
              )),
            ],
          ),
          const SizedBox(height: 8),
          if (cartManager.loading)
            LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation(primaryColor),
              backgroundColor: Colors.white.withAlpha(100),
            ),
          ElevatedButton(
              onPressed: !cartManager.loading ? () async {
                if (Form.of(context)!.validate()) {
                  Form.of(context)!.save();
                  try {
                    await context.read<CartManager>().getEndereco(cartManager.endereco!);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('$e'), backgroundColor: Colors.red));
                  }
                }
              }
              : null,
              style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  onSurface: primaryColor.withAlpha(100)),
              child: const Text('CALCULAR FRETE'))
        ],
      );
    } else if (cartManager.endereco != null && cartManager.endereco!.cep != null) {
      return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
              '${cartManager.endereco!.rua!}, ${cartManager.endereco!.numero?? ''}, ${cartManager.endereco!.complemento?? ''}\n'
              '${cartManager.endereco!.bairro}\n${cartManager.endereco!.cidade} - ${cartManager.endereco!.uf}'));
    } else {
      return Container();
    }
  }
}
