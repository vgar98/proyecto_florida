import 'package:flutter/material.dart';
import 'package:proyectoflorida/src/bloc/customer_bloc.dart';
import 'package:proyectoflorida/src/bloc/provider.dart';
import 'package:proyectoflorida/src/models/customer_model.dart';
import 'package:proyectoflorida/src/providers/customer_provider.dart';
import 'package:proyectoflorida/src/util/utils.dart';

class RegistroPage extends StatefulWidget {
  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldfKey = GlobalKey<ScaffoldState>();

  CustomersBloc customersBloc;
  CustomersProvider clie = new CustomersProvider();
  CustomerModel customer = new CustomerModel();
  bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    customersBloc = Provider.customersBloc(context);

    final CustomerModel proData = ModalRoute.of(context).settings.arguments;
    if (proData != null) {
      customer = proData;
    }
    return Scaffold(
        key: scaffoldfKey,
        appBar: AppBar(
          title: Text('Registrar Cliente'),
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _crearDNI(),
                _crearNombre(),
                _crearApellido(),
                SizedBox(
                  height: 10.0,
                ),
                _crearCategoria(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        )));
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: customer.nombres,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Nombres:'),
      onSaved: (value) => customer.nombres = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del cliente';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearApellido() {
    return TextFormField(
      initialValue: customer.apellidos,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Apellidos:'),
      onSaved: (value) => customer.apellidos = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese los apellidos del cliente';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearDNI() {
    return TextFormField(
      initialValue: customer.dni,
      keyboardType: TextInputType.numberWithOptions(),
      decoration: InputDecoration(labelText: 'DNI:'),
      maxLength: 8,
      onSaved: (value) => customer.dni = value,
      validator: (value) {
        Pattern pattern = '^(\[[0-9]{8}\)';
        RegExp r = new RegExp(pattern);
        if (r.hasMatch(value)) {
          return null;
        } else {
          return 'DNI inválido';
        }
      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
        value: customer.estado,
        title: Text('Disponible'),
        activeColor: Colors.redAccent,
        onChanged: (value) => setState(() {
              customer.estado = value;
            }));
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.redAccent,
      textColor: Colors.white,
      label: Text('Agregar'),
      icon: Icon(Icons.save_alt),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  Widget _crearCategoria() {
    return Row(
      children: <Widget>[
        Text('Tipo'),
        //Icon(Icons.select_all),
        SizedBox(
          width: 30.0,
        ),
        Expanded(
          child: DropdownButton(
              value: customer.valor,
              items: [
                DropdownMenuItem(
                  child: Text("Normal"),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text("Medio"),
                  value: 2,
                ),
                DropdownMenuItem(
                  child: Text("VIP"),
                  value: 3,
                ),
              ],
              onChanged: (value) {
                setState(() {
                  switch (value) {
                    case 1:
                      customer.tipo = 'Normal';
                      customer.valor = value;
                      break;
                    case 2:
                      customer.tipo = 'Medio';
                      customer.valor = value;
                      break;
                    case 3:
                      customer.tipo = 'VIP';
                      customer.valor = value;
                      break;
                    default:
                      customer.tipo = 'Normal';
                      customer.valor = value;
                  }
                  customer.tipo = value;
                });
              }),
        )
      ],
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    final r = await clie.buscarDNI(customer.dni);
    if (customer.id == null) {
      if (r == 0) {
        setState(() {
          _guardando = true;
        });
        customersBloc.agregarCliente(customer);
        Navigator.pop(context);
      } else {
        mostrarAlerta(context, '¡DNI: ${customer.dni} ya existe!');
      }
    } else {
      setState(() {
        _guardando = true;
      });
      customersBloc.editarCliente(customer);
      Navigator.pop(context);
      //productosBloc.editarProducto(producto);
    }

    //mostrarSnakbar('¡Registro Guardado!');
    //Navigator.pop(context);
  }

  void mostrarSnakbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldfKey.currentState.showSnackBar(snackbar);
  }
}
