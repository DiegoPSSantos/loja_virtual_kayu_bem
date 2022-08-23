import 'package:flutter/material.dart';

class SearchDialog extends StatelessWidget {

  const SearchDialog(this.initialSearch);

  final String initialSearch;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned(
              top: 2,
              right: 4,
              left: 4,
              child: Card(
                  child: TextFormField(
                    initialValue: initialSearch,
                    textInputAction: TextInputAction.search,
                      autofocus: true,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 15),
                          prefixIcon: IconButton(
                              icon: const Icon(Icons.arrow_back),
                              color: Theme.of(context).primaryColor,
                              onPressed: () => Navigator.of(context).pop())),
                      onFieldSubmitted: (pesquisa) =>
                          Navigator.of(context).pop(pesquisa))))
        ],
      );
}
