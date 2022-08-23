import 'package:flutter/material.dart';
import 'package:kayu_bem/helpers/string_helper.dart';
import 'package:kayu_bem/models/checkout_manager.dart';
import 'package:provider/src/provider.dart';

import 'radio_widget.dart';

class ListTipoPagamento extends StatefulWidget {
  ListTipoPagamento({required this.groupValue});

  int groupValue;

  @override
  _ListTipoPagamentoState createState() => _ListTipoPagamentoState();
}

class _ListTipoPagamentoState extends State<ListTipoPagamento> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(children: [
          RadioWidget<int>(
              value: 0,
              groupValue: widget.groupValue,
              title: StringHelper.LABEL_CREDIT_CARD,
              onChanged: (value) => setState(() {
                    widget.groupValue = value!;
                    context.read<CheckoutManager>().setTipoPagamento(widget.groupValue);
                  })),
          RadioWidget<int>(
              value: 1,
              groupValue: widget.groupValue,
              title: StringHelper.LABEL_PIX,
              onChanged: (value) => setState(() {
                    widget.groupValue = value!;
                    context.read<CheckoutManager>().setTipoPagamento(widget.groupValue);
                  })),
        ]));
  }
}
