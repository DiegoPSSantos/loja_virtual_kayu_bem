import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kayu_bem_gestor/screens/base/pages_screen.dart';

import 'menu_drawer.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer(this._controller);

  final ZoomDrawerController _controller;

  @override
  Widget build(BuildContext context) => ZoomDrawer(
        style: DrawerStyle.Style1,
        controller: _controller,
        mainScreen: PagesScreen(),
        menuScreen: MenuDrawer(),
        showShadow: true,
        angle: 0,
        slideWidth: MediaQuery.of(context).size.width * .65,
      );
}
