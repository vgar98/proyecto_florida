import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:proyectoflorida/src/bloc/provider.dart';
import 'package:proyectoflorida/src/models/pedido_model.dart';
import 'package:proyectoflorida/src/util/responsive.dart';

class DataSearch extends SearchDelegate {
  DataSearch({
    String hintText,
  }) : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );
  String seleccion = '';

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro Appbar(limpiar o cancelar)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la Izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    if (query.isEmpty) {
      return Container(
        child: Center(
          child: Text('Búsqueda por Cliente'),
        ),
      );
    }

    final pedidosBloc = Provider.pedidosBloc(context);
    pedidosBloc.pedidosPorQuery('$query');
    print('query $query');
    return StreamBuilder(
        stream: pedidosBloc.pedidosQueryStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<PedidoModel2>> snapshot) {
          if (snapshot.hasData) {
            final pedidos = snapshot.data;
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: pedidos.length,
                itemBuilder: (contex, i) => _itemPedidos(contex, pedidos[i]));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container(
        child: Center(
          child: Text('Búsqueda por Cliente'),
        ),
      );
    }

    final pedidosBloc = Provider.pedidosBloc(context);
    pedidosBloc.pedidosPorQuery('$query');
    print('query $query');
    return StreamBuilder(
        stream: pedidosBloc.pedidosQueryStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<PedidoModel2>> snapshot) {
          if (snapshot.hasData) {
            final pedidos = snapshot.data;
            return ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: pedidos.length,
                itemBuilder: (contex, i) => _itemPedidos(contex, pedidos[i]));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  _itemPedidos(BuildContext context, PedidoModel2 pedido) {
    final responsive = Responsive.of(context);
    var color = Colors.black;
    var estadoItem = 'Solicitado';

    if (pedido.entregado == 0) {
      color = Colors.greenAccent;
    } else {
      color = Colors.blue;
      estadoItem = 'Entregado';
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
                  pedido.producto,
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
                  'Cantidad: ',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2),
                  ),
                ),
                Expanded(child: Text('${pedido.cantidad}')),
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Mozo: ',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2),
                  ),
                ),
                Expanded(child: Text(pedido.nombreU))
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Cliente: ',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2),
                  ),
                ),
                Expanded(child: Text(pedido.nombreC))
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Fecha: ',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2),
                  ),
                ),
                Expanded(
                    child: Text('${pedido.dia}-${pedido.mes}-${pedido.year}'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
