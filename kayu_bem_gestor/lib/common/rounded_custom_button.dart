import 'package:flutter/material.dart';

class RoundedCustomButton extends StatelessWidget {
  RoundedCustomButton({required this.onPressed, required this.loading, required this.titulo, this.formKey});

  VoidCallback onPressed;
  bool loading;
  String titulo;
  GlobalKey<FormState>? formKey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 44,
        child: ElevatedButton(
            onPressed: () {
              if (formKey!.currentState!.validate() && !loading) {
                formKey!.currentState!.save();
                onPressed();
              }
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                primary: loading ? Theme.of(context).primaryColor.withAlpha(100) : Theme.of(context).primaryColor),
            child: Text(titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))));
  }
}
