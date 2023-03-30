import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyectoflorida/src/models/estadisticas_model.dart';
import 'package:proyectoflorida/src/models/pedido_model.dart';

class EstadisticasProvider {
  final String _url = 'https://flutter-varios-e5ce3.firebaseio.com/';

  Future<List> contarporComida(int mes) async {
    final url = '$_url/pedidos.json';
    final resp = await http.get(url);

    int normal = 0;
    int medio = 0;
    int vip = 0;

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = PedidoModel.fromJson(prod);
      prodTemp.id = id;
      if (prodTemp.categoria == 1 &&
          prodTemp.fecha.month == mes &&
          prodTemp.entregado == true) {
        if (prodTemp.tipoclie == 1) {
          normal = normal + prodTemp.cantidad;
        }
        if (prodTemp.tipoclie == 2) {
          medio = medio + prodTemp.cantidad;
        }
        if (prodTemp.tipoclie == 3) {
          vip = vip + prodTemp.cantidad;
        }
      }
    });
    var comidas = [
      new EstadisticaModel(1, 'Normal', normal),
      new EstadisticaModel(2, 'Medio', medio),
      new EstadisticaModel(3, 'VIP', vip),
    ];

    return comidas;
  }

  Future<List> contarporBebida(int mes) async {
    final url = '$_url/pedidos.json';
    final resp = await http.get(url);

    int normal = 0;
    int medio = 0;
    int vip = 0;

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = PedidoModel.fromJson(prod);
      prodTemp.id = id;
      if (prodTemp.categoria == 2 &&
          prodTemp.fecha.month == mes &&
          prodTemp.entregado == true) {
        if (prodTemp.tipoclie == 1) {
          normal = normal + prodTemp.cantidad;
        }
        if (prodTemp.tipoclie == 2) {
          medio = medio + prodTemp.cantidad;
        }
        if (prodTemp.tipoclie == 3) {
          vip++;
        }
      }
    });
    var bebidad = [
      new EstadisticaModel(1, 'Normal', normal),
      new EstadisticaModel(2, 'Medio', medio),
      new EstadisticaModel(3, 'VIP', vip),
    ];

    return bebidad;
  }

  Future<List> contarporAperitivo(int mes) async {
    final url = '$_url/pedidos.json';
    final resp = await http.get(url);

    int normal = 0;
    int medio = 0;
    int vip = 0;

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = PedidoModel.fromJson(prod);
      prodTemp.id = id;
      if (prodTemp.categoria == 3 &&
          prodTemp.fecha.month == mes &&
          prodTemp.entregado == true) {
        if (prodTemp.tipoclie == 1) {
          normal = normal + prodTemp.cantidad;
        }
        if (prodTemp.tipoclie == 2) {
          medio = medio + prodTemp.cantidad;
        }
        if (prodTemp.tipoclie == 3) {
          vip = vip + prodTemp.cantidad;
        }
      }
    });
    var aperitivo = [
      new EstadisticaModel(1, 'Normal', normal),
      new EstadisticaModel(2, 'Medio', medio),
      new EstadisticaModel(3, 'VIP', vip),
    ];

    return aperitivo;
  }

  Future<List> contarporLicor(int mes) async {
    final url = '$_url/pedidos.json';
    final resp = await http.get(url);

    int normal = 0;
    int medio = 0;
    int vip = 0;

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = PedidoModel.fromJson(prod);
      prodTemp.id = id;
      if (prodTemp.categoria == 4 &&
          prodTemp.fecha.month == mes &&
          prodTemp.entregado == true) {
        if (prodTemp.tipoclie == 1) {
          normal = normal + prodTemp.cantidad;
        }
        if (prodTemp.tipoclie == 2) {
          medio = medio + prodTemp.cantidad;
        }
        if (prodTemp.tipoclie == 3) {
          vip = vip + prodTemp.cantidad;
        }
      }
    });
    var licor = [
      new EstadisticaModel(1, 'Normal', normal),
      new EstadisticaModel(2, 'Medio', medio),
      new EstadisticaModel(3, 'VIP', vip),
    ];

    return licor;
  }
}
