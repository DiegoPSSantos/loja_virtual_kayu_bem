import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kayu_bem/models/cart_manager.dart';
import 'package:kayu_bem/models/home_manager.dart';
import 'package:kayu_bem/models/pedido.dart';
import 'package:kayu_bem/models/product.dart';
import 'package:kayu_bem/models/product_manager.dart';
import 'package:kayu_bem/models/user_manager.dart';
import 'package:kayu_bem/screens/cart/cart_screen.dart';
import 'package:kayu_bem/screens/products/product_screen.dart';
import 'package:kayu_bem/screens/signup/signup_screen.dart';
import 'package:provider/provider.dart';

import 'models/pedido_manager.dart';
import 'screens/address/address_screen.dart';
import 'screens/base/base_screen.dart';
import 'screens/checkout/checkout_screen.dart';
import 'screens/confirmacao/confirmacao_screen.dart';
import 'screens/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(KayouBemApp());
}

class KayouBemApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // create cria um objeto
          ChangeNotifierProvider(create: (_) => UserManager(), lazy: false),
          ChangeNotifierProvider(create: (_) => ProductManager(), lazy: false),
          ChangeNotifierProvider(create: (_) => HomeManager(), lazy: false),
          ChangeNotifierProxyProvider<UserManager, CartManager>(
            create: (_) => CartManager(),
            lazy: false,
            update: (BuildContext context, userManager, cartManager) =>
                cartManager!..atualizarUsuario(userManager),
          ),
          ChangeNotifierProxyProvider<UserManager, PedidoManager>(
            create: (_) => PedidoManager(),
            lazy: false,
            update: (BuildContext context, userManager, pedidoManager) =>
                pedidoManager!..atualizarUsuario(userManager),
          )
        ],
        child: MaterialApp(
          title: 'Kayu Bem',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.transparent),
              primaryColor: const Color.fromARGB(255, 99, 111, 164),
              scaffoldBackgroundColor: const Color.fromARGB(255, 99, 111, 164),
              appBarTheme: const AppBarTheme(elevation: 0, color: Color.fromARGB(255, 99, 111, 164)),
              visualDensity: VisualDensity.adaptivePlatformDensity),
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/product':
                return MaterialPageRoute(
                    builder: (_) =>
                        ProductScreen(settings.arguments! as Product));
              case '/login':
                return MaterialPageRoute(builder: (_) => LoginScreen());
              case '/signup':
                return MaterialPageRoute(builder: (_) => SignUpScreen());
              case '/cart':
                return MaterialPageRoute(
                    builder: (_) => CartScreen(), settings: settings);
              case '/address':
                return MaterialPageRoute(builder: (_) => AddressScreen());
              case '/checkout':
                return MaterialPageRoute(builder: (_) => CheckoutScreen());
              case '/confirmation':
                return MaterialPageRoute(
                    builder: (_) =>
                        ConfirmacaoScreen(settings.arguments! as Pedido));
              case '/':
              default:
                return MaterialPageRoute(
                    builder: (_) => BaseScreen(), settings: settings);
            }
          },
        ));
  }
}
