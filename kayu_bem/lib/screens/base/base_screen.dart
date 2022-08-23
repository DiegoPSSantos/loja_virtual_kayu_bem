import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kayu_bem/common/custom_drawer/custom_drawer.dart';
import 'package:kayu_bem/models/page_manager.dart';
import 'package:keyboard_actions/external/platform_check/platform_check.dart';
import 'package:provider/provider.dart';

class BaseScreen extends StatefulWidget {
  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  final PageController pageController = PageController();
  final drawerController = ZoomDrawerController();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    configFCM();
  }

  Future<void> configFCM() async {
    final fcm = FirebaseMessaging.instance;

    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification!;
        AndroidNotification android = message.notification!.android!;
        if (notification != null && android != null) {
          showNotificacao(notification.title!, notification.body!);
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification!;
        AndroidNotification android = message.notification!.android!;
        if (notification != null && android != null) {
          showNotificacao(notification.title!, notification.body!);
        }
      });
    }
  }

  Future<void> showNotificacao(String titulo, String mensagem) async {
    showFlash(
        context: context,
        builder: (context, controller) {
          return Flash(
              controller: controller,
              behavior: FlashBehavior.floating,
              position: FlashPosition.top,
              boxShadows: kElevationToShadow[4],
              horizontalDismissDirection: HorizontalDismissDirection.horizontal,
              child: FlashBar(
                title: Text(titulo),
                content: Text(mensagem),
                icon: const Icon(Icons.shopping_cart),
                shouldIconPulse: true,
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => PageManager(pageController)),
      Provider(create: (_) => ZoomDrawerController())
    ], child: Scaffold(body: CustomDrawer(drawerController)));
  }
}
