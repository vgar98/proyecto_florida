import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:proyectoflorida/src/bloc/provider.dart';
import 'package:proyectoflorida/src/models/adutoria.dart';
import 'package:proyectoflorida/src/models/producto_model.dart';
import 'package:proyectoflorida/src/pages/lista_carrito_page.dart';
import 'package:proyectoflorida/src/util/responsive.dart';
import 'package:proyectoflorida/src/util/utils.dart';

class CartaClientePage extends StatefulWidget {
  @override
  _CartaClientePageState createState() => _CartaClientePageState();
}

class _CartaClientePageState extends State<CartaClientePage> {
  List<ProductoModel> _listaCarro = List<ProductoModel>();
  Auditoria audit;

  @override
  Widget build(BuildContext context) {
    audit = ModalRoute.of(context).settings.arguments;
    final productosBloc = Provider.productosBloc(context);

    if (audit.tipo == 3) {
      productosBloc.cargarProductos();
    } else {
      productosBloc.cargarCarta(audit.tipo);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Carta para ${audit.nombreC}'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: GestureDetector(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    size: 30,
                  ),
                  if (_listaCarro.length > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: CircleAvatar(
                        radius: 8.0,
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        child: Text(
                          _listaCarro.length.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12.0),
                        ),
                      ),
                    )
                ],
              ),
              onTap: () {
                if (_listaCarro.isNotEmpty)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CarritoPage(_listaCarro, audit),
                    ),
                  );
              },
            ),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () =>
              Navigator.pushReplacementNamed(context, 'mozo', arguments: audit),
        ),
      ),
      body: _crearListado(productosBloc),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {
    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if (snapshot.hasData) {
          final productos = snapshot.data;
          return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: productos.length,
              itemBuilder: (context, i) => _crearItem(context, productos[i]));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel producto) {
    final Responsive responsive = new Responsive.of(context);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: responsive.hp(0.5),
        horizontal: responsive.wp(3),
      ),
      padding: EdgeInsets.only(
        right: responsive.wp(3),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              width: responsive.wp(27),
              height: responsive.hp(15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  cacheManager: CustomCacheManager(),
                  placeholder: (context, url) => Image(
                    image: AssetImage('assets/log.gif'),
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image(
                    image: AssetImage('assets/image2.png'),
                    fit: BoxFit.cover,
                  ),
                  imageUrl: '${producto.fotoUrl}',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.fill,
                    )),
                  ),
                ),
              )),
          Expanded(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.wp(.8)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(producto.titulo,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: responsive.ip(2),
                        fontWeight: FontWeight.bold)),
                Text('${producto.valor}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: responsive.ip(1.8),
                        color: Colors.grey))
              ],
            ),
          )),
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
              bottom: 8.0,
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                child: (!_listaCarro.contains(producto))
                    ? Icon(
                        Icons.shopping_cart,
                        color: Colors.greenAccent,
                        size: 20,
                      )
                    : Icon(
                        Icons.shopping_cart,
                        color: Colors.redAccent,
                        size: 20,
                      ),
                onTap: () {
                  setState(() {
                    if (!_listaCarro.contains(producto)) {
                      _listaCarro.add(producto);
                    } else {
                      _listaCarro.remove(producto);
                    }
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
