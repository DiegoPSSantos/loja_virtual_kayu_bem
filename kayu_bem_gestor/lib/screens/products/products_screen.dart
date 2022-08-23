import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kayu_bem_gestor/helpers/loading_helper.dart';
import 'package:kayu_bem_gestor/helpers/scroll_listener.dart';
import 'package:kayu_bem_gestor/models/product_manager.dart';
import 'package:provider/provider.dart';

import 'components/category_list.dart';
import 'components/product_list_tile.dart';
import 'components/search_dialog.dart';

class ProductsScreen extends StatelessWidget {
  final ScrollController _controller = ScrollController();
  late final ScrollListener _model;

  ProductsScreen() {
    _model = ScrollListener.initialize(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: InkWell(onTap: () => ZoomDrawer.of(context)!.toggle(), child: const Icon(Icons.menu)),
            title: Consumer<ProductManager>(builder: (_, productManager, __) {
              if (productManager.search.isEmpty) {
                return const Text('PRODUTOS');
              } else {
                return LayoutBuilder(
                    builder: (_, constraints) => GestureDetector(
                        onTap: () async => setPesquisa(context, productManager),
                        child: SizedBox(
                            width: constraints.biggest.width,
                            child: Text(productManager.search, textAlign: TextAlign.center))));
              }
            }),
            centerTitle: true,
            actions: [
              Consumer<ProductManager>(
                builder: (_, productManager, __) {
                  if (productManager.search.isEmpty) {
                    return IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                        icon: const Icon(Icons.search),
                        onPressed: () async => setPesquisa(context, productManager));
                  } else {
                    return IconButton(icon: const Icon(Icons.close), onPressed: () async => productManager.search = '');
                  }
                },
              ),
              Consumer<ProductManager>(
                  builder: (_, productManager, __) => IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      icon: const Icon(Icons.add),
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/add_product', arguments: productManager.categoria))),
              Consumer<ProductManager>(
                  builder: (_, productManager, __) => IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                      icon: const Icon(Icons.delete_forever, color: Colors.redAccent),
                      onPressed: () async {
                        if (await confirm(
                          context,
                          title: const Text('EXCLUSÃO DE PRODUTOS'),
                          content: const Text('Confirma a exclusão dos produtos selecionados?'),
                          textOK: const Text('SIM'),
                          textCancel: const Text('NÃO'),
                        )) {
                          return productManager.removerProdutos();
                        }
                      }))
            ]),
        body: Consumer<ProductManager>(
          builder: (_, productManager, __) {
            final filteredProducts = productManager.filteredProducts;
            return Center(
                child: Stack(children: [
              AnimatedBuilder(
                  animation: _model,
                  builder: (_, __) => Stack(children: [
                        GridView.builder(
                            padding: const EdgeInsets.all(4),
                            controller: _controller,
                            itemCount: filteredProducts.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, childAspectRatio: 1 / 1.5),
                            itemBuilder: (_, index) => ProductListTile(filteredProducts[index])),
                        Positioned(left: 0, right: 0, bottom: _model.bottom, child: CategoryList())
                      ])),
              if (productManager.loading)
                LoadingHelper()
            ]));
          },
        ));
  }

  Future<void> setPesquisa(BuildContext context, ProductManager productManager) async {
    final search = await showDialog<String>(context: context, builder: (_) => SearchDialog(productManager.search));
    if (search != null) {
      productManager.search = search;
    }
  }
}
