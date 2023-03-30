import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
//import 'package:mime_type/mime_type.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';
import 'package:proyectoflorida/src/models/producto_model.dart';

class ProductosProvider {
  final String _url = 'https://flutter-varios-e5ce3.firebaseio.com/';

  Future<bool> crearProducto(ProductoModel producto) async {
    final url = '$_url/producto.json';

    final resp = await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> editarProducto(ProductoModel producto) async {
    final url = '$_url/producto/${producto.id}.json';

    final resp = await http.put(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<List<ProductoModel>> cargarProductos() async {
    final url = '$_url/producto.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<ProductoModel> productos = new List();
    if (decodedData == null) return [];

    decodedData.forEach((id, prod) {
      final prodTemp = ProductoModel.fromJson(prod);
      prodTemp.id = id;

      productos.add(prodTemp);
    });

    return productos;
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

  Future<String> subirImagen(File imagen) async {
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dulx5c8b3/image/upload?upload_preset=mv4nwzgy');
    final mineType = mime(imagen.path).split('/');

    final imageSubir = http.MultipartRequest('POST', url);

    final file = await http.MultipartFile.fromPath('file', imagen.path,
        contentType: MediaType(mineType[0], mineType[1]));

    imageSubir.files.add(file);

    final streamResponse = await imageSubir.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('Algo salió mal');
      print(resp.body);
      return null;
    }
    final rspData = json.decode(resp.body);
    return rspData['secure_url'];
  }
}
