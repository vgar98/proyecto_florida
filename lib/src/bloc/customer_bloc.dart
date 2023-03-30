import 'package:proyectoflorida/src/models/customer_model.dart';
import 'package:proyectoflorida/src/providers/customer_provider.dart';
import 'package:rxdart/rxdart.dart';

class CustomersBloc {
  final _clientesController = new BehaviorSubject<List<CustomerModel>>();
  final _caragandoController = new BehaviorSubject<bool>();

  final _clientesProvier = new CustomersProvider();

  Stream<List<CustomerModel>> get customerStream => _clientesController.stream;
  Stream<bool> get cargando => _caragandoController.stream;

  void cargarClientes() async {
    final clientes = await _clientesProvier.cargarClientes();
    _clientesController.sink.add(clientes);
  }

  void agregarCliente(CustomerModel cliente) async {
    _caragandoController.sink.add(true);
    await _clientesProvier.crearCliente(cliente);
    _caragandoController.sink.add(false);
  }

  void editarCliente(CustomerModel cliente) async {
    _caragandoController.sink.add(true);
    await _clientesProvier.editarCliente(cliente);
    _caragandoController.sink.add(false);
  }

/*
  Future<String> subirFoto(File foto) async {
    _caragandoController.sink.add(true);
    final fotoUrl = await _productosProvier.subirImagen(foto);
    _caragandoController.sink.add(false);
    return fotoUrl;
  }

  

  void borrarProducto(String id) async {
    await _productosProvier.borrarProducto(id);
  }*/

  dispose() {
    _clientesController?.close();
    _caragandoController?.close();
  }
}
