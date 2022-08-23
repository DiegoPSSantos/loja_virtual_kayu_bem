import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kayu_bem/common/custom_icon_button.dart';
import 'package:kayu_bem/models/cart_manager.dart';
import 'package:kayu_bem/models/endereco.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {
  CepInputField({this.retirada = false});

  bool retirada;

  @override
  _CepInputFieldState createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final cepController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartManager = context.watch<CartManager>();
    final primaryColor = Theme.of(context).primaryColor;

    return cartManager.endereco == null || cartManager.endereco!.cep == null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                enabled: !cartManager.loading,
                controller: cepController,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'CEP',
                  hintText: '12.345-678',
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, CepInputFormatter()],
                keyboardType: TextInputType.number,
                validator: (cep) {
                  if (cep!.isEmpty) {
                    return 'Campo obrigatório';
                  } else if (cep.length != 10) {
                    return 'CEP inválido';
                  }
                  return null;
                },
              ),
              if (cartManager.loading)
                LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(primaryColor),
                  backgroundColor: Colors.white.withAlpha(100),
                ),
              ElevatedButton(
                  onPressed: !cartManager.loading
                      ? () async {
                          if (Form.of(context)!.validate()) {
                            try {
                              await context.read<CartManager>().getEnderecoCepAberto(cepController.text);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('$e'),
                                backgroundColor: Colors.red,
                              ));
                            }
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(primary: primaryColor, onSurface: primaryColor.withAlpha(100)),
                  child: const Text('BUSCAR CEP'))
            ],
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  'CEP: ${cartManager.endereco!.cep}',
                  style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                )),
                if (!widget.retirada)
                  CustomIconButton(
                      iconData: Icons.edit,
                      color: primaryColor,
                      tamanho: 20,
                      onTap: () => context.read<CartManager>().removerEndereco())
              ],
            ),
          );
  }
}
