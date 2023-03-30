import 'package:flutter/material.dart';
import 'package:proyectoflorida/src/bloc/customer_bloc.dart';
import 'package:proyectoflorida/src/bloc/provider.dart';
import 'package:proyectoflorida/src/models/customer_model.dart';
import 'package:proyectoflorida/src/providers/customer_provider.dart';
import 'package:proyectoflorida/src/util/responsive.dart';
import 'package:proyectoflorida/src/util/utils.dart';

class RegistroCPage extends StatefulWidget {
  @override
  _RegistroCPageState createState() => _RegistroCPageState();
}

class _RegistroCPageState extends State<RegistroCPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldfKey = GlobalKey<ScaffoldState>();

  CustomersBloc customersBloc;
  CustomersProvider clie = new CustomersProvider();
  CustomerModel customer = new CustomerModel();
  bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    customersBloc = Provider.customersBloc(context);
    String tittle = 'Registrar Cliente';

    final CustomerModel proData = ModalRoute.of(context).settings.arguments;
    if (proData != null) {
      customer = proData;
      tittle = 'Actualizar Cliente';
    }
    return Scaffold(
        appBar: AppBar(
          title: Text(
            tittle,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(3.5)),
          ),
        ),
        key: scaffoldfKey,
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Center(
                child: SingleChildScrollView(
                    child: Container(
                  padding: EdgeInsets.all(15.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32.0),
                          child: Text(
                            "Complete los campos",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        _crearDNI(),
                        _crearNombre(),
                        _crearApellido(),
                        _crearCategoria(),
                        _crearDisponible(),
                        _crearBoton(),
                      ],
                    ),
                  ),
                )),
              ),
            ],
          ),
        ));
  }

  Widget _crearNombre() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
      child: TextFormField(
        initialValue: customer.nombres,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            labelText: 'Nombres:',
            fillColor: Color(0xFFECEDF1),
            hintStyle: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Montserrat',
                color: Colors.black54),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(width: 0, style: BorderStyle.none)),
            filled: true,
            contentPadding: EdgeInsets.all(16),
            suffixIcon: Icon(
              Icons.account_circle,
              color: Colors.redAccent,
            )),
        onSaved: (value) => customer.nombres = value,
        validator: (value) {
          if (value.length < 1) {
            return 'Ingrese el nombre del Cliente';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _crearApellido() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
      child: TextFormField(
        initialValue: customer.apellidos,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            labelText: 'Apellidos:',
            fillColor: Color(0xFFECEDF1),
            hintStyle: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Montserrat',
                color: Colors.black54),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(width: 0, style: BorderStyle.none)),
            filled: true,
            contentPadding: EdgeInsets.all(16),
            suffixIcon: Icon(
              Icons.account_circle,
              color: Colors.redAccent,
            )),
        onSaved: (value) => customer.apellidos = value,
        validator: (value) {
          if (value.length < 1) {
            return 'Ingrese apellido del Cliente';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _crearDNI() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
      child: TextFormField(
        initialValue: customer.dni,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.numberWithOptions(),
        decoration: InputDecoration(
            labelText: 'DNI:',
            fillColor: Color(0xFFECEDF1),
            hintStyle: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Montserrat',
                color: Colors.black54),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(width: 0, style: BorderStyle.none)),
            filled: true,
            contentPadding: EdgeInsets.all(16),
            suffixIcon: Icon(
              Icons.account_box,
              color: Colors.redAccent,
            )),
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
      ),
    );
  }

  Widget _crearDisponible() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
      child: SwitchListTile(
          value: customer.estado,
          title: Text('Disponible'),
          activeColor: Colors.redAccent,
          onChanged: (value) => setState(() {
                customer.estado = value;
              })),
    );
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.redAccent,
      textColor: Colors.white,
      label: Text('GUARDAR'),
      icon: Icon(Icons.data_usage),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  Widget _crearCategoria() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0, left: 40.0, right: 40.0),
      child: Row(
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
      ),
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
