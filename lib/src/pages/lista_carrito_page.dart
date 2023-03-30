import 'package:fancy_dialog/FancyAnimation.dart';
import 'package:fancy_dialog/FancyGif.dart';
import 'package:fancy_dialog/FancyTheme.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:proyectoflorida/src/models/adutoria.dart';
import 'package:proyectoflorida/src/models/pedido_model.dart';
import 'package:proyectoflorida/src/models/producto_model.dart';
import 'package:proyectoflorida/src/providers/pedidos_provider.dart';

class CarritoPage extends StatefulWidget {
  final List<ProductoModel> _cart1;
  final Auditoria audit1;
  CarritoPage(this._cart1, this.audit1);

  @override
  _CarritoPageState createState() =>
      _CarritoPageState(this._cart1, this.audit1);
}

class _CarritoPageState extends State<CarritoPage> {
  PedidoModel pedidomodel = new PedidoModel();
  PedidosProvider pedidos = PedidosProvider();
  _CarritoPageState(this._cart, this.audit);
  final _scrollcontroller = ScrollController();
  var _firstScroll = true;
  bool _enabled = false;
  final List<ProductoModel> _cart;
  final Auditoria audit;

  Container pagoTotal(List<ProductoModel> _cart) {
    print(audit.nombre);
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(left: 120),
      height: 70,
      width: 400,
      color: Colors.grey[200],
      child: Row(
        children: <Widget>[
          Text("Total: ${valorTotal(_cart)}",
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.black))
        ],
      ),
    );
  }

  String valorTotal(List<ProductoModel> listaproductos) {
    double total = 0.0;
    for (int i = 0; i < listaproductos.length; i++) {
      total = total + listaproductos[i].valor * listaproductos[i].cantidad;
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.restaurant_menu),
            onPressed: null,
            color: Colors.white,
          )
        ],
        title: Text(
          'Detalle',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              _cart.length;
            });
          },
          color: Colors.white,
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (_enabled && _firstScroll) {
              _scrollcontroller
                  .jumpTo(_scrollcontroller.position.pixels - details.delta.dy);
            }
          },
          onVerticalDragEnd: (_) {
            if (_enabled) _firstScroll = false;
          },
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _cart.length,
                itemBuilder: (context, index) {
                  final String imagen = _cart[index].fotoUrl;
                  var item = _cart[index];
                  //item.quantity = 0;
                  return Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  width: 150,
                                  height: 150,
                                  child: (imagen == null)
                                      ? Image(
                                          image:
                                              AssetImage('assets/image2.png'),
                                          fit: BoxFit.cover,
                                          height: 75.0,
                                          width: 75.0,
                                        )
                                      : FadeInImage(
                                          image: NetworkImage(imagen),
                                          placeholder:
                                              AssetImage('assets/log.gif'),
                                          fit: BoxFit.cover,
                                          height: 75.0,
                                          width: 75.0),
                                ),
                                SizedBox(width: 10.0),
                                Column(
                                  children: <Widget>[
                                    Text(item.titulo,
                                        style: new TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0,
                                            color: Colors.black)),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          width: 130,
                                          height: 40,
                                          decoration: BoxDecoration(
                                              color: Colors.red[600],
                                              boxShadow: [
                                                BoxShadow(
                                                  blurRadius: 6.0,
                                                  color: Colors.blue[400],
                                                  offset: Offset(0.0, 1.0),
                                                )
                                              ],
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(50.0),
                                              )),
                                          margin: EdgeInsets.only(top: 20.0),
                                          padding: EdgeInsets.all(2.0),
                                          child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 8.0,
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.remove),
                                                onPressed: () {
                                                  setState(() {
                                                    if (_cart[index].cantidad >
                                                        1) {
                                                      _cart[index].cantidad--;
                                                    } else {
                                                      _cart.remove(item);
                                                    }
                                                  });
                                                  valorTotal(_cart);
                                                  // print(_cart);
                                                },
                                                color: Colors.yellow,
                                              ),
                                              Text('${_cart[index].cantidad}',
                                                  style: new TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22.0,
                                                      color: Colors.white)),
                                              IconButton(
                                                icon: Icon(Icons.add),
                                                onPressed: () {
                                                  setState(() {
                                                    _cart[index].cantidad++;
                                                  });
                                                  valorTotal(_cart);
                                                },
                                                color: Colors
                                                    .yellow, // print(_cart);
                                              ),
                                              SizedBox(
                                                height: 8.0,
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 38.0,
                                ),
                                Text(item.valor.toString(),
                                    style: new TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.0,
                                        color: Colors.black))
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.purple,
                      )
                    ],
                  );
                },
              ),
              SizedBox(
                width: 10.0,
              ),
              pagoTotal(_cart),
              SizedBox(
                width: 20.0,
              ),
              Container(
                height: 100,
                width: 200,
                padding: EdgeInsets.only(top: 50),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.green,
                  child: Text("SOLICITAR"),
                  onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => FancyDialog(
                              title: "¿ACEPTA SOLICITAR EL PEDIDO?",
                              descreption: "Click OK",
                              animationType: FancyAnimation.BOTTOM_TOP,
                              theme: FancyTheme.FANCY,
                              gifPath:
                                  FancyGif.MOVE_FORWARD, //'./assets/walp.png',
                              okFun: () => {_pedir(), print("it's working :)")},
                            ))
                  },
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ],
          ))),
    );
  }

  _pedir() async {
    final conf = await pedidos.cargarNumero();
    for (int i = 0; i < _cart.length; i++) {
      pedidomodel.dniU = audit.dni;
      pedidomodel.tipoclie = audit.tipo;
      pedidomodel.nombreU = audit.nombre;
      pedidomodel.dniC = audit.dniC;
      pedidomodel.nombreC = audit.nombreC;
      pedidomodel.producto = _cart[i].titulo;
      pedidomodel.cantidad = _cart[i].cantidad;
      pedidomodel.valor = _cart[i].cantidad * _cart[i].valor;
      pedidomodel.creado = true;
      pedidomodel.fecha = DateTime.now();
      pedidomodel.numero = conf.npedido + 1;
      pedidomodel.categoria = _cart[i].categoria;

      pedidos.crearPedido(pedidomodel);
    }

    conf.npedido++;

    pedidos.editarNumero(conf);

    //Navigator.popUntil(context, ModalRoute.withName('mozo'));

    Navigator.of(context).pushNamedAndRemoveUntil(
        'mozo', (Route<dynamic> route) => false,
        arguments: audit);

    //Navigator.pushReplacementNamed(context, 'mozo', arguments: audit);
  }
}
