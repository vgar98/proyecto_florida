// To parse this JSON data, do
//
//     final usuarioModel = usuarioModelFromJson(jsonString);

import 'dart:convert';

UsuarioModel usuarioModelFromJson(String str) =>
    UsuarioModel.fromJson(json.decode(str));

String usuarioModelToJson(UsuarioModel data) => json.encode(data.toJson());

class UsuarioModel {
  UsuarioModel({
    this.id,
    this.nombre,
    this.usuario,
    this.password,
    this.tipo,
    this.page,
    this.dni,
  });

  String id;
  String nombre;
  String usuario;
  String password;
  String tipo;
  String page;
  String dni;

  factory UsuarioModel.fromJson(Map<String, dynamic> json) => UsuarioModel(
        id: json["id"],
        nombre: json["nombre"],
        usuario: json["usuario"],
        password: json["password"],
        tipo: json["tipo"],
        page: json["page"],
        dni: json["dni"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "usuario": usuario,
        "password": password,
        "tipo": tipo,
        "page": page,
        "dni": dni,
      };
}
