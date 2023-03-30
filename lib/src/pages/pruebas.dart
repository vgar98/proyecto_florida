import 'package:flutter/material.dart';
import 'package:proyectoflorida/src/bloc/provider.dart';
import 'package:proyectoflorida/src/models/pedido_model.dart';
import 'package:proyectoflorida/src/models/producto_model.dart';
import 'package:proyectoflorida/src/routes/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyectoflorida/src/theme/theme.dart';
import 'package:provider/provider.dart' as P;

class Pruebas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    final pBloc2 = Provider.pedidosBloc(context);
    pBloc2.cargarPedidosToDB();

    final pBloc = Provider.pedidosBloc(context);
    pBloc.cargarTopDB();

    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      drawer: _MenuAdmin(),
      body: _crearListado(pBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(PedidosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.topTenStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<TopTenProducts>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
              padding: EdgeInsets.only(left: 25.0, right: 20.0),
              itemCount: productos.length,
              itemBuilder: (context, i) /*=>*/ {
                return new Container(
                  child: _crearItem(context, productosBloc, productos[i]),
                  decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(30)),
                );
              });
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, PedidosBloc productosBloc,
      TopTenProducts producto) {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        //onDismissed: (direccion) => productosBloc.borrarProducto(producto.id),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(producto.producto,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold)),
                      Text('${producto.cantidad}',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 15.0,
                              color: Colors.grey))
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.grey,
              onPressed: () =>
                  Navigator.pushNamed(context, 'carta', arguments: producto),
            ),
          ],
        ),
      ),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.redAccent,
      onPressed: () => Navigator.pushNamed(context, 'carta'),
    );
  }
}

class _MenuAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final apptheme = P.Provider.of<ThemeChanger>(context);
    return Drawer(
        child: Container(
      child: Column(
        children: <Widget>[
          SafeArea(
            child: Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              height: 200,
              child: CircleAvatar(
                backgroundColor: Colors.redAccent,
                child: Text(
                  'A',
                  style: TextStyle(fontSize: 100),
                ),
              ),
            ),
          ),
          Expanded(child: _ListarOpciones()),
          SafeArea(
            bottom: true,
            top: false,
            left: false,
            right: false,
            child: ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.redAccent),
                title: Text('Cerrar Sesión'),
                trailing: Icon(Icons.chevron_right, color: Colors.redAccent),
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context, 'login', (Route<dynamic> route) => false)),
          ),
        ],
      ),
    ));
  }
}

class _ListarOpciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      separatorBuilder: (context, i) => Divider(
        color: Colors.redAccent,
      ),
      itemCount: pageRoutes.length,
      itemBuilder: (context, i) => ListTile(
        leading: FaIcon(pageRoutes[i].icon, color: Colors.redAccent),
        title: Text(pageRoutes[i].titulo),
        trailing: Icon(Icons.chevron_right, color: Colors.redAccent),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => pageRoutes[i].page));
        },
      ),
    );
  }
}
