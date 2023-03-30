import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

bool esNumero(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Información incorrecta'),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

void mostrarAlerta2(BuildContext context, String mensaje) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Aviso'),
          content: Text(mensaje),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
}

class CustomCacheManager extends BaseCacheManager {
  static const key = "customCache";

  static CustomCacheManager _instance;

  factory CustomCacheManager() {
    //creación del Singleton
    if (_instance == null) {
      _instance = new CustomCacheManager._();
    }
    return _instance;
  }

  CustomCacheManager._()
      : super(key,
            maxAgeCacheObject: Duration(days: 30), //duración del cache en dias
            maxNrOfCacheObjects: 200); //maximo de elementos en cache

  Future<String> getFilePath() async {
    //método para obtener el archivo del cache
    var directory = await getTemporaryDirectory();
    return p.join(directory.path, key);
  }
}
