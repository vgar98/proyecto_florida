import 'dart:async';

class Validators {
  final validarusuario =
      StreamTransformer<String, String>.fromHandlers(handleData: (user, sink) {
    if (user.length > 0) {
      sink.add(user);
    } else {
      sink.addError('Ingrese Usuario');
    }
  });
  final validarPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 6) {
      sink.add(password);
    } else {
      sink.addError('Más de 6 caracteres');
    }
  });

  final validarDNI =
      StreamTransformer<String, String>.fromHandlers(handleData: (dni, sink) {
    if (dni == '^(\[[0-9]{8}\)') {
      sink.add(dni);
    } else {
      sink.addError('DNI no válido');
    }
  });
}
