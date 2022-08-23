import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({required this.icone, required this.descricao, required this.path});

  final IconData icone;
  final String descricao;
  final String path;

  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Expanded(child: Text
        (descricao)), Icon
        (icone)]);
}
