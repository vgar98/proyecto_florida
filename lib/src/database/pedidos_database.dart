import 'package:proyectoflorida/src/database/database_provider.dart';
import 'package:proyectoflorida/src/models/pedido_model.dart';

class PedidosDatabase {
  final dbprovider = DatabaseProvider.db;
  insertarPedidosDb(PedidoModel2 pedidos) async {
    final db = await dbprovider.database;

    final res = await db.rawInsert(
        "INSERT OR REPLACE INTO Pedidos (id, numero,categoria, dniU, nombreU, dniC, nombreC, producto, cantidad, valor, creado, entregado, fecha, tipoclie, dia, mes, year) "
        "VALUES('${pedidos.id}', ${pedidos.numero}, ${pedidos.categoria}, '${pedidos.dniU}', '${pedidos.nombreU}', '${pedidos.dniC}', '${pedidos.nombreC}', '${pedidos.producto}', ${pedidos.cantidad}, ${pedidos.valor}, ${pedidos.creado}, ${pedidos.entregado}, '${pedidos.fecha}', ${pedidos.tipoclie}, ${pedidos.dia}, ${pedidos.mes}, ${pedidos.year} )");
    return res;
  }

  updatePedidosDb(PedidoModel2 pedidos) async {
    final db = await dbprovider.database;

    final res = await db.rawUpdate("UPDATE Pedidos SET "
        "numero = ${pedidos.numero},"
        "categoria = ${pedidos.categoria},"
        "dniU = '${pedidos.dniU}',"
        "nombreU = '${pedidos.nombreU}',"
        "dniC = '${pedidos.dniC}',"
        "nombreC = '${pedidos.nombreC}',"
        "producto = '${pedidos.producto}',"
        "cantidad = ${pedidos.cantidad},"
        "valor = ${pedidos.valor},"
        "creado = ${pedidos.creado},"
        "entregado = ${pedidos.entregado},"
        "fecha = '${pedidos.fecha}',"
        "tipoclie = ${pedidos.tipoclie}, "
        "dia = ${pedidos.dia}, "
        "mes = ${pedidos.mes}, "
        "year = ${pedidos.year} "
        "WHERE id = '${pedidos.id}'");
    return res;
  }

  Future<List<PedidoModel2>> consultarPorId(String id) async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Pedidos WHERE id='$id'");

    List<PedidoModel2> list =
        res.isNotEmpty ? res.map((c) => PedidoModel2.fromJson(c)).toList() : [];

    return list;
  }

  Future<List<PedidoModel2>> obtenerPedidos() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery("SELECT * FROM Pedidos");

    List<PedidoModel2> list =
        res.isNotEmpty ? res.map((c) => PedidoModel2.fromJson(c)).toList() : [];
    print(res.length);
    return list;
  }

  Future<List<PedidoModel2>> consultarPorQuery(String query) async {
    final db = await dbprovider.database;
    final res = await db
        .rawQuery("SELECT * FROM Pedidos WHERE nombreC LIKE '%$query%' ");
    List<PedidoModel2> list =
        res.isNotEmpty ? res.map((c) => PedidoModel2.fromJson(c)).toList() : [];
    return list;
  }

  Future<List<TopTenProducts>> topTenProducts() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT producto, SUM(cantidad) FROM Pedidos WHERE entregado =1 GROUP BY producto ORDER BY SUM(cantidad) DESC LIMIT 5");

    List<TopTenProducts> list = res.isNotEmpty
        ? res.map((c) => TopTenProducts.fromJson(c)).toList()
        : [];
    return list;
  }

  Future<List<TopTenClien>> topTenClien() async {
    final db = await dbprovider.database;
    final res = await db.rawQuery(
        "SELECT nombreC, SUM(valor), SUM(cantidad) FROM Pedidos WHERE entregado =1 GROUP BY nombreC ORDER BY SUM(valor) DESC LIMIT 5");

    List<TopTenClien> list =
        res.isNotEmpty ? res.map((c) => TopTenClien.fromJson(c)).toList() : [];
    return list;
  }
}
