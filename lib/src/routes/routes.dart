import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyectoflorida/src/pages/customer_page.dart';
import 'package:proyectoflorida/src/pages/estadisticas_page.dart';
import 'package:proyectoflorida/src/pages/home_page.dart';
import 'package:proyectoflorida/src/pages/pedido_page.dart';
import 'package:proyectoflorida/src/pages/usuario_page.dart';

final pageRoutes = <_Route>[
  _Route(FontAwesomeIcons.productHunt, 'Productos', HomePage()),
  _Route(FontAwesomeIcons.solidChartBar, 'Reportes', StaPage()),
  _Route(FontAwesomeIcons.user, 'Clientes', CustomerPage()),
  _Route(FontAwesomeIcons.userCircle, 'Usuarios', UsuarioPage()),
  _Route(FontAwesomeIcons.shoppingBasket, 'Pedidos', PedidosPage())
];

class _Route {
  final IconData icon;
  final String titulo;
  final Widget page;

  _Route(this.icon, this.titulo, this.page);
}
