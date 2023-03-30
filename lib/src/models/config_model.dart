import 'dart:convert';

ConfigModel configModelFromJson(String str) =>
    ConfigModel.fromJson(json.decode(str));

String configModelToJson(ConfigModel data) => json.encode(data.toJson());

class ConfigModel {
  String id;
  int npedido;
  ConfigModel({
    this.id,
    this.npedido = 0,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
        id: json["id"],
        npedido: json["npedido"],
      );

  Map<String, dynamic> toJson() => {
        //"id": id,
        "npedido": npedido,
      };
}
