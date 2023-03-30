import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proyectoflorida/src/bloc/provider.dart';
import 'package:proyectoflorida/src/models/estadisticas_model.dart';
import 'package:proyectoflorida/src/models/pedido_model.dart';
import 'package:proyectoflorida/src/providers/estadisticas_provider.dart';
import 'package:proyectoflorida/src/util/responsive.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class StaPage extends StatefulWidget {
  @override
  _StaPageState createState() => _StaPageState();
}

class _StaPageState extends State<StaPage> {
  EstadisticasProvider e = new EstadisticasProvider();
  List<charts.Series<EstadisticaModel, String>> _seriesData;

  _generateData() async {
    int mes = DateTime.now().month;
    var comida = await e.contarporComida(mes);
    var bebida = await e.contarporBebida(mes);
    var aperitivo = await e.contarporAperitivo(mes);
    var licor = await e.contarporLicor(mes);
    _seriesData.add(
      charts.Series(
        domainFn: (EstadisticaModel pollution, _) => pollution.tipoclie,
        measureFn: (EstadisticaModel pollution, _) => pollution.cantidad,
        id: '2017',
        data: comida,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (EstadisticaModel pollution, _) =>
            charts.ColorUtil.fromDartColor(Colors.orangeAccent),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (EstadisticaModel pollution, _) => pollution.tipoclie,
        measureFn: (EstadisticaModel pollution, _) => pollution.cantidad,
        id: '2018',
        data: bebida,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (EstadisticaModel pollution, _) =>
            charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (EstadisticaModel pollution, _) => pollution.tipoclie,
        measureFn: (EstadisticaModel pollution, _) => pollution.cantidad,
        labelAccessorFn: (EstadisticaModel pollution, _) => 'Aperitivo',
        id: '2019',
        data: aperitivo,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (EstadisticaModel pollution, _) =>
            charts.ColorUtil.fromDartColor(Colors.deepOrangeAccent),
      ),
    );

    _seriesData.add(
      charts.Series(
        domainFn: (EstadisticaModel pollution, _) => pollution.tipoclie,
        measureFn: (EstadisticaModel pollution, _) => pollution.cantidad,
        labelAccessorFn: (EstadisticaModel pollution, _) => 'Licor',
        id: '2020',
        data: licor,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (EstadisticaModel pollution, _) =>
            charts.ColorUtil.fromDartColor(Colors.greenAccent),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesData = List<charts.Series<EstadisticaModel, String>>();
    _generateData();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    final pBloc2 = Provider.pedidosBloc(context);
    pBloc2.cargarPedidosToDB();

    final pBloc = Provider.pedidosBloc(context);
    pBloc.cargarTopDB();
    final pBloc3 = Provider.pedidosBloc(context);
    pBloc3.cargarTopCDB();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Reportes',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: responsive.ip(4)),
            ),
            bottom: TabBar(indicatorColor: Colors.red, tabs: [
              Tab(icon: Icon(FontAwesomeIcons.productHunt)),
              Tab(icon: Icon(FontAwesomeIcons.userCheck)),
              Tab(icon: Icon(FontAwesomeIcons.solidChartBar)),
            ]),
            backgroundColor: Colors.redAccent,
          ),
          body: TabBarView(children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Top 5 Productos más Solicitados',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.ip(3)),
                      ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.only(
                                topStart: Radius.circular(13),
                                topEnd: Radius.circular(13)),
                            color: Colors.grey[50]),
                        child: StreamBuilder(
                            stream: pBloc.topTenStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<TopTenProducts>> snapshot) {
                              if (snapshot.hasData) {
                                final pedidos = snapshot.data;
                                return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: pedidos.length,
                                    itemBuilder: (contex, i) => _itemPedidos(
                                        contex, pedidos[i], i + 1));
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Top 5 Clientes más Solicitan',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.ip(3)),
                      ),
                      SizedBox(
                        height: responsive.hp(2),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadiusDirectional.only(
                                topStart: Radius.circular(13),
                                topEnd: Radius.circular(13)),
                            color: Colors.grey[50]),
                        child: StreamBuilder(
                            stream: pBloc3.topTenClieStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<TopTenClien>> snapshot) {
                              if (snapshot.hasData) {
                                final pedidos = snapshot.data;
                                return ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: pedidos.length,
                                    itemBuilder: (contex, i) =>
                                        _itemClien(contex, pedidos[i], i + 1));
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Total Pedidos por tipo de Usuario',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: responsive.ip(3)),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.all(
                                      Radius.circular(10)),
                                  color: Colors.orangeAccent),
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(1.5),
                                vertical: responsive.hp(0.5),
                              ),
                              child: Text(
                                'Comida',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(1.5),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: responsive.wp(5),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.all(
                                      Radius.circular(10)),
                                  color: Colors.lightBlueAccent),
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(1.5),
                                vertical: responsive.hp(0.5),
                              ),
                              child: Text(
                                'Bebida',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(1.5),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: responsive.wp(5),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.all(
                                      Radius.circular(10)),
                                  color: Colors.deepOrangeAccent),
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(1.5),
                                vertical: responsive.hp(0.5),
                              ),
                              child: Text(
                                'Aperitivo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(1.5),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: responsive.wp(5),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadiusDirectional.all(
                                      Radius.circular(10)),
                                  color: Colors.greenAccent),
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(1.5),
                                vertical: responsive.hp(0.5),
                              ),
                              child: Text(
                                'Licor',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: responsive.ip(1.5),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: charts.BarChart(
                          _seriesData,
                          animate: true,
                          barGroupingType: charts.BarGroupingType.grouped,
                          animationDuration: Duration(seconds: 5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ])),
    );
  }

  _itemPedidos(BuildContext context, TopTenProducts pedido, int item) {
    final responsive = Responsive.of(context);
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
                      color: Colors.redAccent),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(1.5),
                    vertical: responsive.hp(0.5),
                  ),
                  child: Text(
                    '$item',
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
          ],
        ),
      ),
    );
  }

  _itemClien(BuildContext context, TopTenClien pedido, int item) {
    final responsive = Responsive.of(context);
    var color = Colors.greenAccent;
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
                  pedido.nombreC,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: responsive.ip(2.5)),
                )),
                Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadiusDirectional.all(Radius.circular(10)),
                      color: Colors.redAccent),
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(1.5),
                    vertical: responsive.hp(0.5),
                  ),
                  child: Text(
                    '$item',
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
                Expanded(child: Text('${pedido.categoria}')),
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
                    'S/.${pedido.cantidad}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsive.ip(1.5),
                    ),
                  ),
                )
              ],
            ), /*
            SizedBox(
              height: responsive.hp(1),
            ),
            Row(
              children: <Widget>[
                Text(
                  'Tipo Cliente: ',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: responsive.ip(2),
                  ),
                ),
                Expanded(child: Text(tipo)),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
