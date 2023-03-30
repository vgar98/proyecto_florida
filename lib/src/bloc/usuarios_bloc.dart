import 'package:proyectoflorida/src/models/usuario_model.dart';
import 'package:proyectoflorida/src/providers/usuario_provider.dart';
import 'package:rxdart/rxdart.dart';

class UsuariosBloc {
  final _usuariosController = new BehaviorSubject<List<UsuarioModel>>();
  final _caragandoController = new BehaviorSubject<bool>();

  final _usuariosProvier = new UsuarioProvider();

  Stream<List<UsuarioModel>> get customerStream => _usuariosController.stream;
  Stream<bool> get cargando => _caragandoController.stream;

  void cargarUsuarios() async {
    final usuarios = await _usuariosProvier.cargarUsuarios();
    _usuariosController.sink.add(usuarios);
  }

  void agregarUsuario(UsuarioModel usuario) async {
    _caragandoController.sink.add(true);
    await _usuariosProvier.crearUsuario(usuario);
    _caragandoController.sink.add(false);
  }

  void editarUsuario(UsuarioModel usuario) async {
    _caragandoController.sink.add(true);
    await _usuariosProvier.editarUsuario(usuario);
    _caragandoController.sink.add(false);
  }

/*

  

  void borrarProducto(String id) async {
    await _productosProvier.borrarProducto(id);
  }*/

  dispose() {
    _usuariosController?.close();
    _caragandoController?.close();
  }
}
