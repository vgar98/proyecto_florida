import 'dart:convert';

PedidoModel pedidoModelFromJson(String str) =>
    PedidoModel.fromJson(json.decode(str));

String pedidoModelToJson(PedidoModel data) => json.encode(data.toJson());

class PedidoModel {
  String id;
  int numero;
  int categoria;
  String dniU;
  String nombreU;
  String dniC;
  String nombreC;
  String producto;
  int cantidad;
  double valor;
  bool creado;
  bool entregado;
  DateTime fecha;
  int tipoclie;

  PedidoModel({
    this.id,
    this.dniU = "",
    this.nombreU = "",
    this.dniC = "",
    this.nombreC = "",
    this.producto = "",
    this.cantidad = 0,
    this.valor = 1.0,
    this.creado = false,
    this.entregado = false,
    this.fecha,
    this.numero = 0,
    this.categoria,
    this.tipoclie,
  });

  factory PedidoModel.fromJson(Map<String, dynamic> json) => PedidoModel(
        id: json["id"],
        numero: json["numero"],
        categoria: json["categoria"],
        dniU: json["dniU"],
        nombreU: json["nombreU"],
        dniC: json["dniC"],
        nombreC: json["nombreC"],
        producto: json["producto"],
        cantidad: json["cantidad"],
        valor: json["valor"].toDouble(),
        creado: json["creado"],
        entregado: json["entregado"],
        fecha: DateTime.parse(json["fecha"]),
        tipoclie: json["tipoclie"],
      );

  Map<String, dynamic> toJson() => {
        "numero": numero,
        "tipoclie": tipoclie,
        "categoria": categoria,
        "dniU": dniU,
        "nombreU": nombreU,
        "dniC": dniC,
        "nombreC": nombreC,
        "producto": producto,
        "cantidad": cantidad,
        "valor": valor,
        "creado": creado,
        "entregado": entregado,
        "fecha": fecha.toIso8601String(),
      };
}

class PedidoModel2 {
  String id;
  int numero;
  int categoria;
  String dniU;
  String nombreU;
  String dniC;
  String nombreC;
  String producto;
  int cantidad;
  double valor;
  int creado;
  int entregado;
  String fecha;
  int tipoclie;
  int dia;
  int mes;
  int year;

  PedidoModel2({
    this.id,
    this.dniU,
    this.nombreU,
    this.dniC,
    this.nombreC,
    this.producto,
    this.cantidad,
    this.valor,
    this.creado,
    this.entregado,
    this.fecha,
    this.numero,
    this.categoria,
    this.tipoclie,
    this.year,
    this.mes,
    this.dia,
  });

  factory PedidoModel2.fromJson(Map<String, dynamic> json) => PedidoModel2(
        id: json["id"],
        numero: json["numero"],
        categoria: json["categoria"],
        dniU: json["dniU"],
        nombreU: json["nombreU"],
        dniC: json["dniC"],
        nombreC: json["nombreC"],
        producto: json["producto"],
        cantidad: json["cantidad"],
        valor: json["valor"].toDouble(),
        creado: json["creado"],
        entregado: json["entregado"],
        fecha: json["fecha"],
        tipoclie: json["tipoclie"],
        year: json["year"],
        mes: json["mes"],
        dia: json["dia"],
      );
}

class TopTenProducts {
  String producto;
  int cantidad;

  TopTenProducts({
    this.producto,
    this.cantidad,
  });

  factory TopTenProducts.fromJson(Map<String, dynamic> json) => TopTenProducts(
        producto: json["producto"],
        cantidad: json["SUM(cantidad)"],
      );
}

class TopTenClien {
  String nombreC;
  double cantidad;
  int categoria;

  TopTenClien({
    this.nombreC,
    this.cantidad,
    this.categoria,
  });

  factory TopTenClien.fromJson(Map<String, dynamic> json) => TopTenClien(
        nombreC: json["nombreC"],
        cantidad: json["SUM(valor)"].toDouble(),
        categoria: json["SUM(cantidad)"],
      );
}
