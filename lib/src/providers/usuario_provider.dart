import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyectoflorida/src/models/adutoria.dart';
import 'package:proyectoflorida/src/models/usuario_model.dart';

class UsuarioProvider {
  final String _url = 'https://flutter-varios-e5ce3.firebaseio.com';

  int r = 0;
  Future<Auditoria> autorizacion(String usuario, String password) async {
    final url = '$_url/usuarios.json';
    final resp = await http.get(url);
    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final audit = new Auditoria();
    if (decodedData == null) return audit;
    decodedData.forEach((id, users) {
      final userTemp = UsuarioModel.fromJson(users);
      userTemp.id = id;
      if (userTemp.usuario == usuario && userTemp.password == password) {
        r = 1;
        audit.dni = userTemp.dni;
        audit.nombre = userTemp.nombre;
        audit.page = userTemp.page;
        audit.tipoUser = userTemp.tipo;
      }
    });
    return audit;
  }

  Future<List<UsuarioModel>> cargarUsuarios() async {
    final url = '$_url/usuarios.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<UsuarioModel> usuarios = new List();
    if (decodedData == null) return [];

    decodedData.forEach((id, clie) {
      final clienTemp = UsuarioModel.fromJson(clie);
      clienTemp.id = id;

      usuarios.add(clienTemp);
    });

    return usuarios;
  }

  Future<bool> crearUsuario(UsuarioModel usuario) async {
    final url = '$_url/usuarios.json';

    final resp = await http.post(url, body: usuarioModelToJson(usuario));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> editarUsuario(UsuarioModel usuario) async {
    final url = '$_url/usuarios/${usuario.id}.json';

    final resp = await http.put(url, body: usuarioModelToJson(usuario));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<int> buscarDNI(String dni) async {
    final url = '$_url/usuarios.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    int ex = 0;

    if (decodedData == null) return ex;

    decodedData.forEach((id, usuario) {
      final userTemp = UsuarioModel.fromJson(usuario);

      if (userTemp.dni == dni) {
        ex = 1;
      }
    });
    return ex;
  }
}
