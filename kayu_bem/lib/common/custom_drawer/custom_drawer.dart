import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kayu_bem/common/custom_drawer/menu_drawer.dart';
import 'package:kayu_bem/screens/base/pages_screen.dart';

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
