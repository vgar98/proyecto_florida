import 'dart:io';

import 'package:proyectoflorida/src/models/producto_model.dart';
import 'package:proyectoflorida/src/providers/productos_provider.dart';
import 'package:rxdart/rxdart.dart';

class ProductosBloc {
  final _productosController = new BehaviorSubject<List<ProductoModel>>();
  final _caragandoController = new BehaviorSubject<bool>();

  final _productosProvier = new ProductosProvider();

  Stream<List<ProductoModel>> get productosStream =>
      _productosController.stream;
  Stream<bool> get cargando => _caragandoController.stream;

  void cargarProductos() async {
    final productos = await _productosProvier.cargarProductos();
    _productosController.sink.add(productos);
  }

  void cargarCarta(int valor) async {
    final carta = await _productosProvier.cargarCarta(valor);
    _productosController.sink.add(carta);
  }

  void agregarProducto(ProductoModel producto) async {
    _caragandoController.sink.add(true);
    await _productosProvier.crearProducto(producto);
    _caragandoController.sink.add(false);
  }

  Future<String> subirFoto(File foto) async {
    _caragandoController.sink.add(true);
    final fotoUrl = await _productosProvier.subirImagen(foto);
    _caragandoController.sink.add(false);
    return fotoUrl;
  }

  void editarProducto(ProductoModel producto) async {
    _caragandoController.sink.add(true);
    await _productosProvier.editarProducto(producto);
    _caragandoController.sink.add(false);
  }

  void borrarProducto(String id) async {
    await _productosProvier.borrarProducto(id);
  }

  dispose() {
    _productosController?.close();
    _caragandoController?.close();
  }
}
