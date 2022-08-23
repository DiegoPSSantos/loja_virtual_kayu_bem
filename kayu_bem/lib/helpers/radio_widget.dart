import 'package:flutter/material.dart';

class RadioWidget<T> extends StatelessWidget {

  final T value;
  final T groupValue;
  final String title;
  final ValueChanged<T?> onChanged;

  const RadioWidget({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final title = this.title;
    return InkWell(
      onTap: () => onChanged(value),
      child: Container(
        height: 25,
        child: Row(
          children: [
            _customRadioButton,
            const SizedBox(width: 5),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final isSelected = value == groupValue;
    return Container(
      height: 18,
      width: 18,
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : null,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isSelected ? Colors.black12 : Colors.grey[300]!,
          width: 2,
        ),
      )
    );
  }
}
