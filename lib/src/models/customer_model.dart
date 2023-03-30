import 'dart:convert';

CustomerModel customerModelFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  String id;
  String nombres;
  String apellidos;
  String tipo;
  String dni;
  bool estado;
  int valor;

  CustomerModel({
    this.id,
    this.nombres = '',
    this.apellidos = '',
    this.tipo = 'Normal',
    this.dni = '',
    this.estado = true,
    this.valor = 1,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        id: json["id"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        tipo: json["tipo"],
        dni: json["dni"],
        estado: json["estado"],
        valor: json["valor"],
      );

  Map<String, dynamic> toJson() => {
        //"id": id,
        "nombres": nombres,
        "apellidos": apellidos,
        "tipo": tipo,
        "dni": dni,
        "estado": estado,
        "valor": valor,
      };
}
