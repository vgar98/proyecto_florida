import 'dart:convert';

Auditoria auditoriaFromJson(String str) => Auditoria.fromJson(json.decode(str));

String auditoriaToJson(Auditoria data) => json.encode(data.toJson());

class Auditoria {
  String dni;
  String nombre;
  String page;
  String dniC;
  String nombreC;
  int tipo;
  String tipoUser;

  Auditoria({
    this.dni = "",
    this.nombre = "",
    this.page = "",
    this.dniC = "",
    this.tipo = 0,
    this.nombreC = "",
    this.tipoUser,
  });

  factory Auditoria.fromJson(Map<String, dynamic> json) => Auditoria(
        dni: json["dni"],
        nombre: json["nombre"],
        page: json["page"],
        dniC: json["dniC"],
        nombreC: json["nombreC"],
        tipo: json["tipo"],
        tipoUser: json["tipoUser"],
      );

  Map<String, dynamic> toJson() => {
        "dni": dni,
        "nombre": nombre,
        "page": page,
        "dniC": dniC,
        "nombreC": nombreC,
        "tipo": tipo,
        "tipoUser": tipoUser,
      };
}
