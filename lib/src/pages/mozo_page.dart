import 'package:flutter/material.dart';
import 'package:proyectoflorida/src/models/adutoria.dart';
import 'package:proyectoflorida/src/providers/customer_provider.dart';
import 'package:proyectoflorida/src/util/responsive.dart';
import 'package:proyectoflorida/src/util/utils.dart';

class MozoPage extends StatefulWidget {
  @override
  _MozoPageState createState() => _MozoPageState();
}

class _MozoPageState extends State<MozoPage> {
  final formKey = GlobalKey<FormState>();

  final scaffoldfKey = GlobalKey<ScaffoldState>();

  CustomersProvider clie = new CustomersProvider();

  Auditoria audit;

  @override
  Widget build(BuildContext context) {
    audit = ModalRoute.of(context).settings.arguments;
    final responsive = Responsive.of(context);
    return Scaffold(
      key: scaffoldfKey,
      appBar: AppBar(
        title: Text(
          'Bienvenido ${audit.nombre}',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: responsive.ip(3)),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, 'login', (Route<dynamic> route) => false);
            },
            color: Colors.white,
          )
        ],
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Form(
            key: formKey,
            child: _dniForm(context),
          ),
        ),
      ),
    );
  }

  Widget _dniForm(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
              child: Container(
            height: 100,
          )),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 3.0)
                ]),
            child: Column(
              children: <Widget>[
                Text('Ingrese DNI del Cliente',
                    style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0),
                _creardni(),
                SizedBox(height: 30.0),
                _crearBoton()
              ],
            ),
          ),
          SizedBox(height: 30.0),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _creardni() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          keyboardType: TextInputType.numberWithOptions(),
          decoration: InputDecoration(labelText: 'DNI:'),
          maxLength: 8,
          onSaved: (value) => audit.dniC = value,
          validator: (value) {
            Pattern pattern = '^(\[[0-9]{8}\)';
            RegExp r = new RegExp(pattern);
            if (r.hasMatch(value)) {
              return null;
            } else {
              return 'DNI inválido';
            }
          },
        ));
  }

  Widget _crearBoton() {
    return RaisedButton(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
        child: Text('Consultar'),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      elevation: 0.0,
      color: Colors.redAccent,
      textColor: Colors.white,
      onPressed: () => _submit(),
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();
    final info = await clie.buscarDNIC(audit.dniC);

    if (info[0] != 0) {
      if (info[0] != 4) {
        audit.tipo = info[0];
        audit.nombreC = info[1];
        print(audit.nombreC);
        Navigator.pushReplacementNamed(context, 'cartacliente',
            arguments: audit);
      } else {
        mostrarAlerta2(context, 'Cliente no puede realizar pedidos');
      }
    } else {
      mostrarAlerta(context, '¡DNI: ${audit.dniC} no registrado!');
    }
  }
}
