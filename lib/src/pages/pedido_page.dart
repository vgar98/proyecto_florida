import 'package:flutter/material.dart';
import 'package:proyectoflorida/src/bloc/provider.dart';
import 'package:proyectoflorida/src/models/pedido_model.dart';
import 'package:proyectoflorida/src/util/buscar_delegate.dart';
import 'package:proyectoflorida/src/util/responsive.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PedidosPage extends StatelessWidget {
  final _refresController = RefreshController(initialRefresh: false);
  void _onRefresh(BuildContext context) async {
    final pedidoBloc = Provider.pedidosBloc(context);
    pedidoBloc.cargarPedidos();
    _refresController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final pedidoBloc = Provider.pedidosBloc(context);
    pedidoBloc.cargarPedidos();
    final responsive = Responsive.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Pedidos',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(4),
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: responsive.ip(3.5),
                  ),
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: DataSearch(hintText: 'Buscar'));
                  },
                )
              ],
            ),
          ),
        ),
        body: _lista(context, pedidoBloc));
  }

  Widget _lista(BuildContext context, PedidosBloc pedidosBloc) {
    return SafeArea(
        child: Column(
      children: <Widget>[
        Expanded(
            child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                  topStart: Radius.circular(13), topEnd: Radius.circular(13)),
              color: Colors.grey[50]),
          child: SmartRefresher(
            controller: _refresController,
            onRefresh: () {
              _onRefresh(context);
            },
            child: StreamBuilder(
                stream: pedidosBloc.pedidosStream,
                builder: (BuildContext context,
                    AsyncSnapshot<List<PedidoModel>> snapshot) {
                  if (snapshot.hasData) {
                    final pedidos = snapshot.data;
                    return SmartRefresher(
                      controller: _refresController,
                      onRefresh: () {
                        _onRefresh(context);
                      },
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: pedidos.length,
                          itemBuilder: (contex, i) =>
                              _itemPedidos(contex, pedidos[i])),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ))
      ],
    ));
  }

  _itemPedidos(BuildContext context, PedidoModel pedido) {
    final responsive = Responsive.of(context);
    var color = Colors.black;
    var estadoItem = 'Solicitado';

    if (pedido.entregado == false) {
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
                    child: Text(
                        '${pedido.fecha.day}-${pedido.fecha.month}-${pedido.fecha.year} / ${pedido.fecha.hour}:${pedido.fecha.second}'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
