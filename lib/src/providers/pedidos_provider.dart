import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyectoflorida/src/database/pedidos_database.dart';
import 'package:proyectoflorida/src/models/config_model.dart';
import 'package:proyectoflorida/src/models/pedido_model.dart';
import 'package:proyectoflorida/src/models/producto_model.dart';

class PedidosProvider {
  final String _url = 'https://flutter-varios-e5ce3.firebaseio.com/';
  final pedidosDB = PedidosDatabase();

  Future<bool> crearPedido(PedidoModel pedido) async {
    final url = '$_url/pedidos.json';

    final resp = await http.post(url, body: pedidoModelToJson(pedido));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> editarNumero(ConfigModel config) async {
    final url = '$_url/config/${config.id}.json';

    final resp = await http.put(url, body: configModelToJson(config));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<ConfigModel> cargarNumero() async {
    final url = '$_url/config.json';
    final resp = await http.get(url);
    int n = 0;

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final ConfigModel conf = new ConfigModel();
    if (decodedData == null) return conf;

    decodedData.forEach((id, prod) {
      final prodTemp = ConfigModel.fromJson(prod);
      prodTemp.id = id;
      conf.id = prodTemp.id;
      conf.npedido = prodTemp.npedido;
    });

    return conf;
  }

  Future<List<PedidoModel>> cargarPedidos() async {
    final url = '$_url/pedidos.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<PedidoModel> productos = new List();
    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = PedidoModel.fromJson(prod);
      prodTemp.id = id;

      productos.add(prodTemp);
    });

    return productos;
  }

  Future<List<PedidoModel>> cargarPedidosToDB() async {
    final url = '$_url/pedidos.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<PedidoModel> productos = new List();
    if (decodedData == null) return [];

    decodedData.forEach((id, prod) async {
      final prodTemp = PedidoModel.fromJson(prod);
      prodTemp.id = id;
      final dato = await pedidosDB.consultarPorId(id);
      PedidoModel2 p = PedidoModel2();
      p.id = prodTemp.id;
      p.numero = prodTemp.numero;
      p.categoria = prodTemp.categoria;
      p.dniU = prodTemp.dniU;
      p.nombreU = prodTemp.nombreU;
      p.dniC = prodTemp.dniC;
      p.nombreC = prodTemp.nombreC;
      p.producto = prodTemp.producto;
      p.cantidad = prodTemp.cantidad;
      p.valor = prodTemp.valor;
      if (prodTemp.creado) {
        p.creado = 1;
      } else {
        p.creado = 0;
      }
      if (prodTemp.entregado) {
        p.entregado = 1;
      } else {
        p.entregado = 0;
      }
      p.fecha = prodTemp.fecha.toIso8601String();
      p.tipoclie = prodTemp.tipoclie;
      p.dia = prodTemp.fecha.day;
      p.mes = prodTemp.fecha.month;
      p.year = prodTemp.fecha.year;

      if (dato.length > 0) {
        await pedidosDB.updatePedidosDb(p);
      } else {
        await pedidosDB.insertarPedidosDb(p);
      }
      productos.add(prodTemp);
    });

    return productos;
  }

  Future<List<PedidoModel>> cargarPedidosBarra() async {
    final url = '$_url/pedidos.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<PedidoModel> productos = new List();
    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = PedidoModel.fromJson(prod);
      prodTemp.id = id;

      if (prodTemp.entregado == false &&
          (prodTemp.categoria == 2 || prodTemp.categoria == 4)) {
        productos.add(prodTemp);
      }
    });

    return productos;
  }

  Future<List<PedidoModel>> cargarPedidosCocina() async {
    final url = '$_url/pedidos.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<PedidoModel> productos = new List();
    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = PedidoModel.fromJson(prod);
      prodTemp.id = id;

      if (prodTemp.entregado == false &&
          (prodTemp.categoria == 1 || prodTemp.categoria == 3)) {
        productos.add(prodTemp);
      }
    });

    return productos;
  }

  Future<bool> changeStatus(PedidoModel pedido) async {
    final url = '$_url/pedidos/${pedido.id}.json';

    final resp = await http.put(url, body: pedidoModelToJson(pedido));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<ProductoModel>> cargarCarta(int valor) async {
    final url = '$_url/producto.json';
    final resp = await http.get(url);

    final r = valor * 15;

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();
    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;

      if (prodTemp.valor <= r) {
        productos.add(prodTemp);
      }
    });

    return productos;
  }

  Future<int> borrarProducto(String id) async {
    final url = '$_url/producto/$id.json';
    final resp = await http.delete(url);

    print(json.decode(resp.body));

    return 1;
  }
}
