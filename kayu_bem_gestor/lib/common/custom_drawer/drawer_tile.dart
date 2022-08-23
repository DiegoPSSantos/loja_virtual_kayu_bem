import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kayu_bem_gestor/models/page_manager.dart';
import 'package:provider/provider.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile(
      {required this.iconData, required this.title, required this.page});

  final IconData iconData;
  final String title;
  final int page;

  @override
  Widget build(BuildContext context) {
    final int curPage = context
        .watch<PageManager>()
        .initPage;

    return Consumer<PageManager>(
        builder: (_, pageManager, __) {
          return InkWell(
            onTap: () {
              pageManager.setPage(page);
              ZoomDrawer.of(context)!.toggle();
            },
            child: SizedBox(
              height: 60,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Icon(
                        iconData,
                        size: 32,
                        color: curPage == page ? Theme
                            .of(context)
                            .primaryColor : Colors.grey
                    ),
                  ),
                  Text(
                      title,
                      style: TextStyle(
                          fontSize: 16,
                          color: curPage == page ? Theme
                              .of(context)
                              .primaryColor : Colors.grey
                      )
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}
