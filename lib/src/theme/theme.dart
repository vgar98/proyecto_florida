import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  bool _darkTheme = false;

  ThemeData _temaActual;

  bool get darkTheme => this._darkTheme;
  ThemeData get temaActual => this._temaActual;

  ThemeChanger(int theme) {
    switch (theme) {
      case 1: //normal
        _darkTheme = false;
        _temaActual = ThemeData(primaryColor: Colors.redAccent);
        break;
      case 2: //dark
        _darkTheme = true;
        _temaActual = ThemeData.dark();
        break;

      default:
        _darkTheme = false;
        _temaActual = ThemeData(primaryColor: Colors.redAccent);
    }
  }

  set darkTheme(bool value) {
    _darkTheme = value;

    if (value) {
      _temaActual = ThemeData.dark();
    } else {
      _temaActual = ThemeData(primaryColor: Colors.redAccent);
    }

    print(_darkTheme);
    notifyListeners();
  }
}
