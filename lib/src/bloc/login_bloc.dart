import 'dart:async';

import 'package:proyectoflorida/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators {
  final _usuarioController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Recuperar los datos del Stream

  Stream<String> get usuarioStream =>
      _usuarioController.stream.transform(validarusuario);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validarPassword);

  Stream<bool> get validarformlogin =>
      Rx.combineLatest2(usuarioStream, passwordStream, (e, p) => true);
  //Insertar valores al Stream

  Function(String) get chageUsuario => _usuarioController.sink.add;
  Function(String) get chagePassword => _passwordController.sink.add;

  //Obtener el ultimo valor ingresado a los Streams

  String get usuario => _usuarioController.value;
  String get password => _passwordController.value;

  dispose() {
    _usuarioController?.close();
    _passwordController?.close();
  }
}
