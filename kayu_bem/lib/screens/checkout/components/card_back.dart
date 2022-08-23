import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kayu_bem/models/credit_card.dart';
import 'package:kayu_bem/screens/checkout/components/card_text_field.dart';

class CardBack extends StatelessWidget {

  const CardBack({required this.creditCard, required this.cvvFocus});

  final FocusNode cvvFocus;
  final CreditCard creditCard;

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        elevation: 16,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 200,
          color: Colors.black54,
          child: Column(
            children: [
              Container(
                color: Colors.black,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 16),
              ),
              Row(
                children: [
                  Expanded(
                      flex: 70,
                      child: Container(
                        color: Colors.grey[500],
                        margin: const EdgeInsets.only(left: 12),
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8),
                        child: CardTextField(
                          hint: '123',
                          maxLength: 3,
                          bold: true,
                          initialValue: creditCard.securityCode,
                          textAlign: TextAlign.end,
                          focusNode: cvvFocus,
                          textInputType: TextInputType.number,
                          formatadores: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (cvv) {
                            if (cvv!.length != 3) {
                              return 'Inválido';
                            }
                            return null;
                          },
                          onSaved: creditCard.setCVV,
                        ),
                      )),
                  Expanded(flex: 30, child: Container())
                ],
              )
            ],
          ),
        ));
  }
}
