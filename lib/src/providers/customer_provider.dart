import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyectoflorida/src/models/customer_model.dart';

class CustomersProvider {
  final String _url = 'https://flutter-varios-e5ce3.firebaseio.com';

  Future<List<CustomerModel>> cargarClientes() async {
    final url = '$_url/clientes.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    final List<CustomerModel> clientes = new List();
    if (decodedData == null) return [];

    decodedData.forEach((id, clie) {
      final clienTemp = CustomerModel.fromJson(clie);
      clienTemp.id = id;

      clientes.add(clienTemp);
    });

    return clientes;
  }

  Future<bool> crearCliente(CustomerModel cliente) async {
    final url = '$_url/clientes.json';

    final resp = await http.post(url, body: customerModelToJson(cliente));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<bool> editarCliente(CustomerModel cliente) async {
    final url = '$_url/clientes/${cliente.id}.json';

    final resp = await http.put(url, body: customerModelToJson(cliente));

    final decodedData = json.decode(resp.body);

    print(decodedData);

    return true;
  }

  Future<int> buscarDNI(String dni) async {
    final url = '$_url/clientes.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    int ex = 0;

    if (decodedData == null) return ex;

    decodedData.forEach((id, cliente) {
      final userTemp = CustomerModel.fromJson(cliente);

      if (userTemp.dni == dni) {
        ex = userTemp.valor;
      }
    });
    return ex;
  }

  Future<List> buscarDNIC(String dni) async {
    final url = '$_url/clientes.json';
    final resp = await http.get(url);

    final Map<String, dynamic> decodedData = json.decode(resp.body);
    List data = [0, ''];

    if (decodedData == null) return data;

    decodedData.forEach((id, cliente) {
      final userTemp = CustomerModel.fromJson(cliente);

      if (userTemp.dni == dni) {
        if (userTemp.estado == true) {
          data[0] = userTemp.valor;
          data[1] = '${userTemp.nombres} ${userTemp.apellidos}';
        } else {
          data[0] = 4;
        }
      }
    });
    return data;
  }
}
