import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:proyectoflorida/src/bloc/provider.dart';
import 'package:proyectoflorida/src/models/producto_model.dart';
import 'package:proyectoflorida/src/routes/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyectoflorida/src/theme/theme.dart';
import 'package:provider/provider.dart' as P;
import 'package:proyectoflorida/src/util/responsive.dart';
import 'package:proyectoflorida/src/util/utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatelessWidget {
  final _refresController = RefreshController(initialRefresh: false);
  void _onRefresh(BuildContext context) async {
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();
    _refresController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Productos',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: responsive.ip(4)),
        ),
      ),
      drawer: _MenuAdmin(),
      body: _crearListado(context, productosBloc),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(BuildContext context, ProductosBloc productosBloc) {
    return SmartRefresher(
      controller: _refresController,
      onRefresh: () {
        _onRefresh(context);
      },
      child: StreamBuilder(
        stream: productosBloc.productosStream,
        builder: (BuildContext context,
            AsyncSnapshot<List<ProductoModel>> snapshot) {
          if (snapshot.hasData) {
            final productos = snapshot.data;
            return SmartRefresher(
              controller: _refresController,
              onRefresh: () {
                _onRefresh(context);
              },
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: productos.length,
                  itemBuilder: (context, i) =>
                      _crearItem(context, productosBloc, productos[i])),
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

  Widget _crearItem(BuildContext context, ProductosBloc productosBloc,
      ProductoModel producto) {
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
      child: Dismissible(
        key: UniqueKey(),
        background: Container(
          color: Colors.red,
        ),
        onDismissed: (direccion) => productosBloc.borrarProducto(producto.id),
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
                          fontSize: responsive.ip(2.1),
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
