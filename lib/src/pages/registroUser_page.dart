import 'package:flutter/material.dart';
import 'package:proyectoflorida/src/bloc/provider.dart';
import 'package:proyectoflorida/src/models/usuario_model.dart';
import 'package:proyectoflorida/src/providers/usuario_provider.dart';
import 'package:proyectoflorida/src/util/responsive.dart';
import 'package:proyectoflorida/src/util/utils.dart';

class RegistroUserPage extends StatefulWidget {
  @override
  _RegistroUserPageState createState() => _RegistroUserPageState();
}

class _RegistroUserPageState extends State<RegistroUserPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldfKey = GlobalKey<ScaffoldState>();
  UsuariosBloc userBloc;
  UsuarioProvider userP = new UsuarioProvider();
  UsuarioModel user = new UsuarioModel();
  bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    userBloc = Provider.usuarioBloc(context);
    String tittle = 'Registrar Usuario';

    final UsuarioModel proData = ModalRoute.of(context).settings.arguments;
    if (proData != null) {
      user = proData;
      tittle = 'Actualizar Usuario';
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
                          _crearUsuario(),
                          _crearPass(),
                          _crearCategoria(),
                          _crearBoton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _crearNombre() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
      child: TextFormField(
        initialValue: user.nombre,
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
              Icons.account_box,
              color: Colors.redAccent,
            )),
        onSaved: (value) => user.nombre = value,
        validator: (value) {
          if (value.length < 1) {
            return 'Ingrese el nombre del Usuario';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _crearUsuario() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
      child: TextFormField(
        initialValue: user.usuario,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            labelText: 'Usario:',
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
        onSaved: (value) => user.usuario = value,
        validator: (value) {
          if (value.length < 4) {
            return 'Ingrese el nombre de usuario';
          } else {
            return null;
          }
        },
      ),
    );
  }

  Widget _crearPass() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 24.0, right: 24.0),
      child: TextFormField(
        obscureText: true,
        textAlign: TextAlign.left,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            labelText: 'Contraseña:',
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
              Icons.lock,
              color: Colors.redAccent,
            )),
        onSaved: (value) => user.password = value,
        validator: (value) {
          if (value.length < 6 && user.password == null) {
            return 'Ingrese más caracteres';
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
        initialValue: user.dni,
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
        onSaved: (value) => user.dni = value,
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
            child: DropdownButton<String>(
                value: user.tipo,
                items: [
                  DropdownMenuItem(
                    child: Text("Administrador"),
                    value: "admin",
                  ),
                  DropdownMenuItem(
                    child: Text("Mozo"),
                    value: "mozo",
                  ),
                  DropdownMenuItem(
                    child: Text("Barman"),
                    value: "barra",
                  ),
                  DropdownMenuItem(
                    child: Text("Cocinero"),
                    value: "cocina",
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    switch (value) {
                      case "admin":
                        user.tipo = 'admin';
                        user.page = 'home';
                        break;
                      case "mozo":
                        user.tipo = 'mozo';
                        user.page = 'mozo';
                        break;
                      case "barra":
                        user.tipo = 'barra';
                        user.page = 'pedidos';
                        break;
                      case "cocina":
                        user.tipo = 'cocina';
                        user.page = 'pedidos';
                        break;
                      default:
                        user.tipo = 'admin';
                        user.page = 'home';
                    }
                    user.tipo = value;
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

    final r = await userP.buscarDNI(user.dni);
    if (user.id == null) {
      if (r == 0) {
        setState(() {
          _guardando = true;
        });
        userBloc.agregarUsuario(user);
        Navigator.pop(context);
      } else {
        mostrarAlerta(context, '¡DNI: ${user.dni} ya existe!');
      }
    } else {
      setState(() {
        _guardando = true;
      });
      userBloc.editarUsuario(user);
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
