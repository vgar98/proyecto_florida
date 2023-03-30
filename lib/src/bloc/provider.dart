import 'package:flutter/material.dart';

import 'package:proyectoflorida/src/bloc/customer_bloc.dart';
export 'package:proyectoflorida/src/bloc/customer_bloc.dart';

import 'package:proyectoflorida/src/bloc/login_bloc.dart';
export 'package:proyectoflorida/src/bloc/login_bloc.dart';

import 'package:proyectoflorida/src/bloc/pedidos_bloc.dart';
export 'package:proyectoflorida/src/bloc/pedidos_bloc.dart';

import 'package:proyectoflorida/src/bloc/productos_bloc.dart';
export 'package:proyectoflorida/src/bloc/productos_bloc.dart';

import 'package:proyectoflorida/src/bloc/usuarios_bloc.dart';
export 'package:proyectoflorida/src/bloc/usuarios_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = LoginBloc();
  final _productosBloc = ProductosBloc();
  final _customersBloc = CustomersBloc();
  final _usuarioBloc = UsuariosBloc();
  final _pedidosBloc = PedidosBloc();

  static Provider _instancia;

  factory Provider({Key key, Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }

    return _instancia;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>()).loginBloc;
  }

  static ProductosBloc productosBloc(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>())
        ._productosBloc;
  }

  static CustomersBloc customersBloc(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>())
        ._customersBloc;
  }

  static UsuariosBloc usuarioBloc(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>())
        ._usuarioBloc;
  }

  static PedidosBloc pedidosBloc(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<Provider>())
        ._pedidosBloc;
  }
}
