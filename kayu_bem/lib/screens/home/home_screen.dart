import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kayu_bem/helpers/loading_helper.dart';
import 'package:kayu_bem/models/cart_manager.dart';
import 'package:kayu_bem/models/home_manager.dart';
import 'package:kayu_bem/models/product_manager.dart';
import 'package:kayu_bem/screens/home/components/section_staggered.dart';
import 'package:provider/provider.dart';

import 'components/section_carroussel.dart';
import 'components/section_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 99, 111, 164),
              Color.fromARGB(255, 232, 203, 192),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          ),
          CustomScrollView(
            slivers: [
              SliverAppBar(
                snap: true,
                floating: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: const FlexibleSpaceBar(
                  title: Text('HOME'),
                  centerTitle: true,
                ),
                leading: InkWell(onTap: () => ZoomDrawer.of(context)!.toggle(), child: const Icon(Icons.menu)),
                actions: [
                  Consumer<CartManager>(
                      builder: (_, cartManager, __) => Badge(
                          position: BadgePosition.topEnd(top: 0, end: 5),
                          showBadge: cartManager.items.isNotEmpty,
                          badgeContent: Text(cartManager.items.length.toString()),
                          child: IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            color: Colors.white,
                            onPressed: () => Navigator.of(context).pushNamed('/cart'),
                          )))
                ],
              ),
              Consumer<HomeManager>(
                builder: (_, homeManager, __) {
                  final List<Widget> children = homeManager.sections.map<Widget>((section) {
                    switch (section.tipo) {
                      case 'Carroussel':
                        return SectionCarroussel(section);
                      case 'List':
                        return SectionList(section);
                      case 'Staggered':
                        return SectionStaggered(section);
                      case 'SquadList':
                        return SectionList(section);
                      default:
                        return Container();
                    }
                  }).toList();
                    return SliverList(delegate: SliverChildListDelegate(children));
                  // ]);
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
