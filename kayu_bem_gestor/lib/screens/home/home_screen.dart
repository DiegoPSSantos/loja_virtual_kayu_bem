
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kayu_bem_gestor/models/home_manager.dart';
import 'package:kayu_bem_gestor/screens/home/components/section_staggered.dart';
import 'package:provider/provider.dart';
import 'components/section_carroussel.dart';
import 'components/section_list.dart';
import 'components/section_staggered.dart';

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
