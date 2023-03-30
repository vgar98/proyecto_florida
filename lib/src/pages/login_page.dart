import 'package:flutter/material.dart';
import 'package:proyectoflorida/src/bloc/provider.dart';
import 'package:proyectoflorida/src/providers/usuario_provider.dart';
import 'package:proyectoflorida/src/util/utils.dart';

class LoginPage extends StatelessWidget {
  final usuarioProvider = new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _crearFondo(context),
        _loginForm(context),
      ],
    ));
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SafeArea(
              child: Container(
            height: 230.0,
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
                Text('Ingreso', style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 60.0),
                _crearUsuario(bloc),
                SizedBox(height: 30.0),
                _crearPassword(bloc),
                SizedBox(height: 30.0),
                _crearBoton(bloc)
              ],
            ),
          ),
          SizedBox(height: 30.0),
          FlatButton(
              child: Text('--'),
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, 'registro')),
          SizedBox(
            height: 100.0,
          )
        ],
      ),
    );
  }

  Widget _crearUsuario(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.usuarioStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  icon: Icon(Icons.account_circle, color: Colors.redAccent),
                  hintText: 'ejem: mozouser',
                  labelText: 'Nombre de Usuario',
                  counterText: snapshot.data,
                  errorText: snapshot.error),
              onChanged: bloc.chageUsuario,
            ));
      },
    );
  }

  Widget _crearPassword(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.passwordStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                  icon: Icon(Icons.lock, color: Colors.redAccent),
                  labelText: 'Contraseña',
                  //counterText: snapshot.data,
                  errorText: snapshot.error),
              onChanged: bloc.chagePassword,
            ));
      },
    );
  }

  Widget _crearBoton(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.validarformlogin,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Ingresar'),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 0.0,
          color: Colors.redAccent,
          textColor: Colors.white,
          onPressed: snapshot.hasData ? () => _login(bloc, context) : null,
        );
      },
    );
  }

  _login(LoginBloc bloc, BuildContext context) async {
    // int info = await usuarioProvider.autorizacion(bloc.usuario, bloc.password);
    final info =
        await usuarioProvider.autorizacion(bloc.usuario, bloc.password);
    if (info.page != '') {
      Navigator.pushReplacementNamed(context, info.page, arguments: info);
      bloc.chagePassword("");
      bloc.chageUsuario("");
    } else {
      mostrarAlerta(context, "Usuario o Contraseña invalido");
    }
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final fondoRojo = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: <Color>[
        Color.fromRGBO(125, 2, 19, 1.0),
        Color.fromRGBO(79, 9, 20, 1.0),
      ])),
    );

    final circulo = Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.05)),
    );

    return Stack(
      children: <Widget>[
        fondoRojo,
        Positioned(
          top: 90.0,
          left: 30.0,
          child: circulo,
        ),
        Positioned(
          top: -40.0,
          right: -30.0,
          child: circulo,
        ),
        Positioned(
          bottom: -50.0,
          right: -10.0,
          child: circulo,
        ),
        Positioned(
          bottom: 120.0,
          right: 20.0,
          child: circulo,
        ),
        Positioned(
          bottom: -50.0,
          left: -20.0,
          child: circulo,
        ),
        Container(
          padding: EdgeInsets.only(top: 40.0),
          child: Column(
            children: <Widget>[
              Image(
                image: AssetImage('assets/e-florida1.png'),
              ),
              SizedBox(
                height: 2.0,
                width: double.infinity,
              ),
              Text('¡Hola!',
                  style: TextStyle(color: Colors.white, fontSize: 25.0))
            ],
          ),
        )
      ],
    );
  }
}
