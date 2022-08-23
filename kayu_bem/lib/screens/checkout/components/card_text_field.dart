import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardTextField extends StatelessWidget {
  const CardTextField(
      {this.texto,
      this.bold = false,
      this.maxLength,
      this.validator,
      this.textInputType,
      this.textAlign,
      this.hint,
      this.focusNode,
      this.onSubmitted,
      this.onSaved,
      this.onChange,
      this.initialValue,
      required this.formatadores})
      : inputAction =
            onSubmitted == null ? TextInputAction.done : TextInputAction.next;

  final String? texto;
  final bool bold;
  final String? hint;
  final int? maxLength;
  final String? initialValue;
  final FocusNode? focusNode;
  final TextAlign? textAlign;
  final Function(String)? onSubmitted;
  final Function(String)? onChange;
  final TextInputType? textInputType;
  final TextInputAction? inputAction;
  final List<TextInputFormatter> formatadores;
  final FormFieldValidator<String>? validator;
  final FormFieldSetter<String>? onSaved;

  @override
  Widget build(BuildContext context) {
    return FormField(
        validator: validator,
        initialValue: initialValue,
        onSaved: onSaved,
        builder: (state) => Padding(
              padding: const EdgeInsets.all(2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (texto != null)
                    Row(
                      children: [
                        Text(
                          texto!,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        if (state.hasError)
                          const Text(
                            ' INVÁLIDO',
                            style: TextStyle(
                                letterSpacing: 1,
                                color: Colors.redAccent,
                                fontWeight: FontWeight.w700,
                                fontSize: 11),
                          )
                      ],
                    ),
                  TextFormField(
                    initialValue: initialValue,
                    maxLength: maxLength,
                    textAlign: textAlign ?? TextAlign.start,
                    cursorColor: Colors.white,
                    style: TextStyle(
                        color: texto == null && state.hasError
                            ? Colors.redAccent.withAlpha(150)
                            : Colors.white,
                        fontWeight: bold ? FontWeight.bold : FontWeight.w500),
                    decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: TextStyle(
                            color: texto == null && state.hasError
                                ? Colors.redAccent.withAlpha(200)
                                : Colors.white.withAlpha(100),
                            fontSize: 18),
                        border: InputBorder.none,
                        isDense: true,
                        counterText: '',
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 2)),
                    keyboardType: textInputType,
                    inputFormatters: formatadores,
                    focusNode: focusNode,
                    textInputAction: inputAction,
                    onChanged:
                        (texto) {
                      // if (texto.replaceAll(' ', '').length == 6) {
                      //   onChange;
                      // }
                     state.didChange(texto);
                    },
                    onFieldSubmitted: onSubmitted,
                  ),
                ],
              ),
            ));
  }


}
