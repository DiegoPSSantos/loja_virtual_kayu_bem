import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/checkout_manager.dart';
import 'package:kayu_bem/models/credit_card.dart';
import 'package:kayu_bem/models/meio_pagamento.dart';
import 'package:kayu_bem/screens/checkout/components/card_back.dart';
import 'package:kayu_bem/screens/checkout/components/card_front.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/src/provider.dart';

class CreditCardWidget extends StatefulWidget {
  const CreditCardWidget(this.creditCard);

  final CreditCard creditCard;

  @override
  _CreditCardWidgetState createState() => _CreditCardWidgetState();
}

class _CreditCardWidgetState extends State<CreditCardWidget> {
  final GlobalKey<FlipCardState> cardKey = GlobalKey();

  final FocusNode fnNumero = FocusNode();
  final FocusNode fnValidade = FocusNode();
  final FocusNode fnTitular = FocusNode();
  final FocusNode fnCVV = FocusNode();

  @override
  Widget build(BuildContext context) {
    List<MeioPagamento>? bandeiras = context.read<CheckoutManager>().cartoesCreditoAceitos;
    return KeyboardActions(
      config: _buildConfig(context),
      autoScroll: false,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Row(children: [
                  Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5), border: Border.all(color: Colors.white)),
                          child: ListView(shrinkWrap: true, children: [
                            const Text(
                              'Bandeiras Aceitas',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            if (bandeiras != null) Row(
                                children: bandeiras!
                                    .map((bandeira) => Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                        child: getIcone(bandeira.id!)))
                                    .toList())
                          ])))
                ])),
            FlipCard(
              key: cardKey,
              front: CardFront(
                creditCard: widget.creditCard,
                numeroFocus: fnNumero,
                validadeFocus: fnValidade,
                titularFocus: fnTitular,
                finished: () {
                  cardKey.currentState!.toggleCard();
                  fnCVV.requestFocus();
                },
              ),
              back: CardBack(creditCard: widget.creditCard, cvvFocus: fnCVV),
              speed: 800,
              flipOnTouch: false,
            ),
            TextButton.icon(
                style: TextButton.styleFrom(primary: Colors.white),
                onPressed: () => cardKey.currentState!.toggleCard(),
                icon: const Icon(Icons.flip_camera_android),
                label: const Text('Virar o cartão'))
          ],
        ),
      ),
    );
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
        keyboardBarColor: Colors.grey[200],
        actions: [
          KeyboardActionsItem(focusNode: fnNumero),
          KeyboardActionsItem(focusNode: fnValidade),
          KeyboardActionsItem(focusNode: fnTitular, toolbarButtons: [
            (_) {
              return GestureDetector(
                  onTap: () {
                    cardKey.currentState!.toggleCard();
                    fnCVV.requestFocus();
                  },
                  child: const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Text(
                        'CONTINUAR',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )));
            }
          ]),
        ]);
  }

  SvgPicture getIcone(String id) {
    SvgPicture brandIcon = SvgPicture.asset(StringHelper.BRAND_GENERIC, height: 30);
    switch (id) {
      case 'amex':
        brandIcon = SvgPicture.asset(StringHelper.BRAND_AMEX, height: 30);
        break;
      case 'cabal':
        brandIcon = SvgPicture.asset(StringHelper.BRAND_CABAL, height: 30);
        break;
      case 'elo':
        brandIcon = SvgPicture.asset(StringHelper.BRAND_ELO, height: 30);
        break;
      case 'hipercard':
        brandIcon = SvgPicture.asset(StringHelper.BRAND_HIPERCARD, height: 30);
        break;
      case 'master':
        brandIcon = SvgPicture.asset(StringHelper.BRAND_MASTERCARD, height: 30);
        break;
      case 'visa':
        brandIcon = SvgPicture.asset(StringHelper.BRAND_VISA, height: 30);
        break;
    }
    return brandIcon;
  }
}
