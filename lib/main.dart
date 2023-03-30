import 'package:flutter/material.dart';
import 'package:proyectoflorida/src/bloc/provider.dart';
import 'package:proyectoflorida/src/pages/atencion_page.dart';
import 'package:proyectoflorida/src/pages/carta_cliente_page.dart';
import 'package:proyectoflorida/src/pages/carta_page.dart';
import 'package:proyectoflorida/src/pages/home_page.dart';
import 'package:proyectoflorida/src/pages/login_page.dart';
import 'package:proyectoflorida/src/pages/mozo_page.dart';
import 'package:proyectoflorida/src/pages/pruebas.dart';
import 'package:proyectoflorida/src/pages/registroUser_page.dart';
import 'package:proyectoflorida/src/pages/registro_customer.dart';
import 'package:proyectoflorida/src/pages/registro_page.dart';
import 'package:proyectoflorida/src/theme/theme.dart';
import 'package:provider/provider.dart' as P;

void main() => runApp(P.ChangeNotifierProvider(
    create: (_) => new ThemeChanger(1), child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final temaActual = P.Provider.of<ThemeChanger>(context).temaActual;

    return Provider(
        child: MaterialApp(
      theme: temaActual,
      debugShowCheckedModeBanner: false,
      title: 'AppFlorida',
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'registro': (BuildContext context) => RegistroPage(),
        'home': (BuildContext context) => HomePage(),
        'carta': (BuildContext context) => CartaPage(),
        'mozo': (BuildContext context) => MozoPage(),
        'registroc': (BuildContext context) => RegistroCPage(),
        'registroU': (BuildContext context) => RegistroUserPage(),
        'pruebas': (BuildContext context) => Pruebas(),
        'cartacliente': (BuildContext context) => CartaClientePage(),
        'pedidos': (BuildContext context) => PedidoPage(),
      },
    ));
  }
}
