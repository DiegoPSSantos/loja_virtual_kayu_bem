import 'package:brasil_fields/brasil_fields.dart';
import 'package:credit_card_type_detector/credit_card_type_detector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kayu_bem/models/cart_manager.dart';
import 'package:kayu_bem/models/checkout_manager.dart';
import 'package:kayu_bem/models/credit_card.dart';
import 'package:kayu_bem/screens/checkout/components/card_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/src/provider.dart';

class CardFront extends StatelessWidget {
  CardFront(
      {required this.numeroFocus,
      required this.validadeFocus,
      required this.titularFocus,
      required this.finished,
      required this.creditCard});

  final VoidCallback finished;

  final FocusNode numeroFocus;
  final FocusNode validadeFocus;
  final FocusNode titularFocus;

  final CreditCard creditCard;

  final formatadorData = MaskTextInputFormatter(mask: '!#/20##', filter: {'#': RegExp('[0-9]'), '!': RegExp('[0-1]')});

  @override
  Widget build(BuildContext context) {

    void consultarParcelas(String numero) {
      if (numero.replaceAll(' ', '').length == 6) {
        num total = context.read<CartManager>().precoProdutos;
        context.read<CheckoutManager>().consultarParcelas(numero, total);
      }
    }

    return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 16,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
            height: 200,
            color: Colors.black45,
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CardTextField(
                      hint: '0000 0000 0000 0000',
                      texto: 'Número',
                      bold: true,
                      initialValue: creditCard.number,
                      focusNode: numeroFocus,
                      textInputType: TextInputType.number,
                      formatadores: [FilteringTextInputFormatter.digitsOnly, CartaoBancarioInputFormatter()],
                      validator: (numero) {
                        if (numero!.length != 19) {
                          return 'Inválido';
                        } else if (detectCCType(numero) == CreditCardType.unknown) {
                          return 'Inválido';
                        }
                        return null;
                      },
                      onSubmitted: (_) => validadeFocus.requestFocus(),
                      onSaved: creditCard.setNumber,
                    ),
                    CardTextField(
                      hint: '11/2020',
                      texto: 'Validade',
                      initialValue: creditCard.expirationDate,
                      focusNode: validadeFocus,
                      textInputType: TextInputType.number,
                      formatadores: [formatadorData],
                      validator: (validade) {
                        if (validade!.length != 7) {
                          return 'Inválido';
                        } else if (int.parse(validade.split('/')[0]) > 12) {
                          return 'Inválido';
                        } else {
                          final anoAtual = DateTime.now().year;
                          if (int.parse(validade.split('/')[1]) < anoAtual) {
                            return 'Inválido';
                          }
                        }

                        return null;
                      },
                      onSubmitted: (_) => titularFocus.requestFocus(),
                      onSaved: creditCard.setExpirationDate,
                    ),
                    CardTextField(
                      hint: 'Nome do Cliente',
                      texto: 'Titular',
                      bold: true,
                      initialValue: creditCard.holder,
                      focusNode: titularFocus,
                      textInputType: TextInputType.text,
                      formatadores: [],
                      validator: (nome) {
                        if (nome!.isEmpty || nome.length < 2) {
                          return 'Inválido';
                        }
                        return null;
                      },
                      onSubmitted: (_) => finished(),
                      onSaved: creditCard.setHolder,
                    )
                  ],
                ))
              ],
            )));
  }
}
