import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kayu_bem_gestor/models/dashboard_manager.dart';
import 'package:kayu_bem_gestor/screens/products/add_product_screen.dart';
import 'package:kayu_bem_gestor/screens/products/edit_product_screen.dart';
import 'package:provider/provider.dart';
import 'models/home_manager.dart';
import 'models/pedido.dart';
import 'models/pedido_manager.dart';
import 'models/product.dart';
import 'models/product_manager.dart';
import 'models/user_manager.dart';
import 'models/users_manager.dart';
import 'screens/address/address_screen.dart';
import 'screens/base/base_screen.dart';
import 'screens/confirmacao/confirmacao_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/products/product_screen.dart';
import 'screens/signup/signup_screen.dart';

Future<void> main() async {
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
          ChangeNotifierProvider(create: (_) => DashboardManager(), lazy: false),
          ChangeNotifierProvider(create: (_) => UserManager(), lazy: false),
          ChangeNotifierProvider(create: (_) => ProductManager(), lazy: false),
          ChangeNotifierProvider(create: (_) => HomeManager(), lazy: false),
          ChangeNotifierProxyProvider<UserManager, PedidoManager>(
            create: (_) => PedidoManager(),
            lazy: false,
            update: (BuildContext context, userManager, pedidoManager) => pedidoManager!..atualizarPedidos(),
          ),
          ChangeNotifierProxyProvider<UserManager, UsersManager>(
            create: (_) => UsersManager(),
            lazy: false,
            update: (_, userManager, usersManager) => usersManager!..atualizarUsuarios(userManager),
          ),
        ],
        child: MaterialApp(
          title: 'Kayu Bem',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: const Color.fromARGB(255, 99, 111, 164),
              scaffoldBackgroundColor: const Color.fromARGB(255, 99, 111, 164),
              appBarTheme: const AppBarTheme(elevation: 0, color: Color.fromARGB(255, 99, 111, 164)),
              visualDensity: VisualDensity.adaptivePlatformDensity),
          initialRoute: '/login',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/product':
                return MaterialPageRoute(builder: (_) => ProductScreen(settings.arguments! as Product));
              case '/add_product':
                return MaterialPageRoute(builder: (_) => AddProductScreen(categoria: settings.arguments! as String));
              case '/edit_product':
                return MaterialPageRoute(builder: (_) => EditProductScreen(settings.arguments! as Product));
              case '/login':
                return MaterialPageRoute(builder: (_) => LoginScreen());
              case '/address':
                return MaterialPageRoute(builder: (_) => AddressScreen());
              case '/confirmation':
                return MaterialPageRoute(builder: (_) => ConfirmacaoScreen(settings.arguments! as Pedido));
              case '/':
              default:
                return MaterialPageRoute(builder: (_) => BaseScreen(), settings: settings);
            }
          },
        ));
  }
}
