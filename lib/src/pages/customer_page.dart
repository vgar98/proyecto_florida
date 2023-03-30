import 'package:flutter/material.dart';
import 'package:proyectoflorida/src/bloc/customer_bloc.dart';
import 'package:proyectoflorida/src/bloc/provider.dart';
import 'package:proyectoflorida/src/models/customer_model.dart';
import 'package:proyectoflorida/src/util/responsive.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomerPage extends StatelessWidget {
  final _refresController = RefreshController(initialRefresh: false);
  void _onRefresh(BuildContext context) async {
    final customersBloc = Provider.customersBloc(context);
    customersBloc.cargarClientes();
    _refresController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final customersBloc = Provider.customersBloc(context);
    customersBloc.cargarClientes();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Clientes',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: responsive.ip(4)),
        ),
      ),
      body: Stack(
        children: <Widget>[
          _crearListado(context, customersBloc),
        ],
      ),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(BuildContext context, CustomersBloc customersBloc) {
    return SmartRefresher(
      controller: _refresController,
      onRefresh: () {
        _onRefresh(context);
      },
      child: StreamBuilder(
        stream: customersBloc.customerStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<CustomerModel>> snapshot) {
          if (snapshot.hasData) {
            final clientes = snapshot.data;
            return SmartRefresher(
              controller: _refresController,
              onRefresh: () {
                _onRefresh(context);
              },
              child: ListView.builder(
                itemCount: clientes.length,
                itemBuilder: (context, i) =>
                    _crearItem(context, customersBloc, clientes[i]),
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

  Widget _crearItem(BuildContext context, CustomersBloc customersBloc,
      CustomerModel customer) {
    final responsive = Responsive.of(context);
    var color = Colors.black;
    var estadoItem = 'Admin';

    if (customer.tipo == 'VIP') {
      color = Colors.orangeAccent;
    }
    if (customer.tipo == 'Medio') {
      color = Colors.cyan;
    }
    if (customer.tipo == 'Normal') {
      color = Colors.deepPurpleAccent;
    }

    if (customer.estado == true) {
      estadoItem = 'Habilitado';
    } else {
      estadoItem = 'No habilitado';
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
                  '${customer.nombres} ${customer.apellidos}',
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
                    customer.tipo,
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
                Expanded(child: Text(customer.dni)),
              ],
            ),
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Estado: ',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2),
                  ),
                ),
                Expanded(child: Text(estadoItem))
              ],
            ),
          ],
        ),
      ),
      onTap: () =>
          Navigator.pushNamed(context, 'registroc', arguments: customer),
    );
  }

  _crearBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.redAccent,
      onPressed: () => Navigator.pushNamed(context, 'registroc'),
    );
  }
}
