import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kayu_bem_gestor/models/cart_manager.dart';
import 'package:kayu_bem_gestor/models/endereco.dart';
import 'package:provider/provider.dart';

class AddressInputField extends StatelessWidget {
  const AddressInputField(this.endereco);

  final Endereco endereco;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final cartManager = context.watch<CartManager>();

    if (endereco.cep != null && cartManager.precoEntrega == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: endereco.rua,
            enabled: !cartManager.loading,
            decoration: const InputDecoration(
                isDense: true,
                labelText: 'Rua/Avenida',
                hintText: 'Av. Brasil'),
            validator: (text) => text!.isEmpty ? 'Campo Obrigatório' : null,
            onSaved: (t) => endereco.rua = t,
          ),
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                initialValue: endereco.numero,
                enabled: !cartManager.loading,
                decoration: const InputDecoration(
                    isDense: true, labelText: 'Número', hintText: '123'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                validator: (text) => text!.isEmpty ? 'Campo Obrigatório' : null,
                onSaved: (t) => endereco.numero = t,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: TextFormField(
                initialValue: endereco.complemento,
                enabled: !cartManager.loading,
                decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Complemento',
                    hintText: 'Opcional'),
                onSaved: (t) => endereco.complemento = t,
              ))
            ],
          ),
          TextFormField(
            initialValue: endereco.bairro,
            enabled: !cartManager.loading,
            decoration: const InputDecoration(
                isDense: true, labelText: 'Bairro', hintText: 'Águas Claras'),
            validator: (text) => text!.isEmpty ? 'Campo Obrigatório' : null,
            onSaved: (t) => endereco.bairro = t,
          ),
          Row(
            children: [
              Expanded(
                  flex: 3,
                  child: TextFormField(
                    enabled: false,
                    initialValue: endereco.cidade,
                    decoration: const InputDecoration(
                        isDense: true,
                        labelText: 'Cidade',
                        hintText: 'Brasília'),
                    validator: (text) =>
                        text!.isEmpty ? 'Campo Obrigatório' : null,
                    onSaved: (t) => endereco.cidade = t,
                  )),
              const SizedBox(width: 16),
              Expanded(
                  child: TextFormField(
                autocorrect: false,
                enabled: false,
                textCapitalization: TextCapitalization.characters,
                initialValue: endereco.uf,
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
                onSaved: (t) => endereco.uf = t,
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
                    await context.read<CartManager>().getEndereco(endereco);
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
    } else if (endereco.cep != null) {
      print(cartManager.precoEntrega);
      return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
              '${endereco.rua!}, ${endereco.numero}, ${endereco.complemento}\n'
              '${endereco.bairro}\n${endereco.cidade} - ${endereco.uf}'));
    } else {
      return Container();
    }
  }
}
