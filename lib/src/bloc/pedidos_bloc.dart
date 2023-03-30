import 'package:proyectoflorida/src/database/pedidos_database.dart';
import 'package:proyectoflorida/src/models/pedido_model.dart';
import 'package:proyectoflorida/src/providers/pedidos_provider.dart';
import 'package:rxdart/rxdart.dart';

class PedidosBloc {
  final _pedidosController = new BehaviorSubject<List<PedidoModel>>();
  final _pedidos2Controller = new BehaviorSubject<List<PedidoModel2>>();
  final _pedidosPorQuery = new BehaviorSubject<List<PedidoModel2>>();
  final _toTenController = new BehaviorSubject<List<TopTenProducts>>();
  final _toTenClieController = new BehaviorSubject<List<TopTenClien>>();
  final _caragandoController = new BehaviorSubject<bool>();

  final _pedidosProvier = new PedidosProvider();
  final _pedidosDB = PedidosDatabase();

  Stream<List<PedidoModel>> get pedidosStream => _pedidosController.stream;
  Stream<List<PedidoModel2>> get pedidos2Stream => _pedidos2Controller.stream;
  Stream<List<PedidoModel2>> get pedidosQueryStream => _pedidosPorQuery.stream;
  Stream<List<TopTenProducts>> get topTenStream => _toTenController.stream;
  Stream<List<TopTenClien>> get topTenClieStream => _toTenClieController.stream;
  Stream<bool> get cargando => _caragandoController.stream;

  void cargarPedidosToDB() async {
    _pedidos2Controller.sink.add(await _pedidosDB.obtenerPedidos());
    _pedidosController.sink.add(await _pedidosProvier.cargarPedidosToDB());
    _pedidos2Controller.sink.add(await _pedidosDB.obtenerPedidos());
  }

  void pedidosPorQuery(String query) async {
    _pedidosPorQuery.sink.add(await _pedidosDB.consultarPorQuery(query));
  }

  void cargarTopDB() async {
    _toTenController.sink.add(await _pedidosDB.topTenProducts());
  }

  void cargarTopCDB() async {
    _toTenClieController.sink.add(await _pedidosDB.topTenClien());
  }

  void cargarPedidos() async {
    final pedidos = await _pedidosProvier.cargarPedidos();
    _pedidosController.sink.add(pedidos);
  }

  void cargarPedidosBarra() async {
    final pedidos = await _pedidosProvier.cargarPedidosBarra();
    _pedidosController.sink.add(pedidos);
  }

  void cargarPedidosCocina() async {
    final pedidos = await _pedidosProvier.cargarPedidosCocina();
    _pedidosController.sink.add(pedidos);
  }

  void chageStatus(PedidoModel pedido) async {
    _caragandoController.sink.add(true);
    await _pedidosProvier.changeStatus(pedido);
    _caragandoController.sink.add(false);
  }

  dispose() {
    _pedidos2Controller?.close();
    _pedidosPorQuery?.close();
    _toTenClieController?.close();
    _toTenController?.close();
    _pedidosController?.close();
    _caragandoController?.close();
  }
}
