import 'package:flutter/material.dart';
import 'package:proyectoflorida/src/bloc/usuarios_bloc.dart';
import 'package:proyectoflorida/src/bloc/provider.dart';
import 'package:proyectoflorida/src/models/usuario_model.dart';
import 'package:proyectoflorida/src/util/responsive.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuarioPage extends StatelessWidget {
  final _refresController = RefreshController(initialRefresh: false);
  void _onRefresh(BuildContext context) async {
    final usuariosBloc = Provider.usuarioBloc(context);
    usuariosBloc.cargarUsuarios();
    _refresController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final usuariosBloc = Provider.usuarioBloc(context);
    usuariosBloc.cargarUsuarios();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Usuarios',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: responsive.ip(4)),
        ),
      ),
      body: Stack(
        children: <Widget>[
          _crearListado(context, usuariosBloc),
        ],
      ),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(BuildContext context, UsuariosBloc usuarioBloc) {
    return SmartRefresher(
      controller: _refresController,
      onRefresh: () {
        _onRefresh(context);
      },
      child: StreamBuilder(
        stream: usuarioBloc.customerStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<UsuarioModel>> snapshot) {
          if (snapshot.hasData) {
            final clientes = snapshot.data;
            return SmartRefresher(
              controller: _refresController,
              onRefresh: () {
                _onRefresh(context);
              },
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: clientes.length,
                itemBuilder: (context, i) =>
                    _crearItem(context, usuarioBloc, clientes[i]),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _crearItem(
      BuildContext context, UsuariosBloc customersBloc, UsuarioModel usuario) {
    final responsive = Responsive.of(context);
    var color = Colors.black;
    var estadoItem = 'Admin';

    if (usuario.tipo == 'admin') {
      color = Colors.blueAccent;
      estadoItem = 'Administrador';
    }
    if (usuario.tipo == 'mozo') {
      color = Colors.orangeAccent;
      estadoItem = 'Mozo';
    }
    if (usuario.tipo == 'barra') {
      color = Colors.cyan;
      estadoItem = 'Barman';
    }
    if (usuario.tipo == 'cocina') {
      color = Colors.deepPurpleAccent;
      estadoItem = 'Cocinero';
    }
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]),
            borderRadius: BorderRadius.all(
              Radius.circular(13),
            ),
            color: Colors.grey[50]),
        padding: EdgeInsets.symmetric(
            horizontal: responsive.wp(3), vertical: responsive.hp(2)),
        margin: EdgeInsets.symmetric(
            horizontal: responsive.wp(3), vertical: responsive.hp(0.2)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Text(
                  usuario.nombre,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(2.5)),
                )),
                Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadiusDirectional.all(Radius.circular(10)),
                      color: color),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(1.5),
                    vertical: responsive.hp(0.5),
                  ),
                  child: Text(
                    estadoItem,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(1.5),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text(
                  'DNI: ',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2),
                  ),
                ),
                Expanded(child: Text(usuario.dni)),
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Usuario: ',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2),
                  ),
                ),
                Expanded(child: Text(usuario.usuario))
              ],
            ),
          ],
        ),
      ),
      onTap: () =>
          Navigator.pushNamed(context, 'registroU', arguments: usuario),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.redAccent,
      onPressed: () => Navigator.pushNamed(context, 'registroU'),
    );
  }
}
