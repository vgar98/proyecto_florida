import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:proyectoflorida/src/bloc/provider.dart';
import 'package:proyectoflorida/src/models/producto_model.dart';
import 'package:proyectoflorida/src/util/responsive.dart';
import 'package:proyectoflorida/src/util/utils.dart' as utils;

class CartaPage extends StatefulWidget {
  @override
  _CartaPageState createState() => _CartaPageState();
}

class _CartaPageState extends State<CartaPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldfKey = GlobalKey<ScaffoldState>();

  ProductosBloc productosBloc;
  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive.of(context);
    productosBloc = Provider.productosBloc(context);
    String tittle = 'Agregar Producto';

    final ProductoModel proData = ModalRoute.of(context).settings.arguments;
    if (proData != null) {
      producto = proData;
      tittle = 'Actualizar Producto';
    }
    return Scaffold(
        key: scaffoldfKey,
        appBar: AppBar(
          title: Text(
            tittle,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: responsive.ip(3)),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_size_select_actual),
              onPressed: _seleccionarFoto,
            ),
            IconButton(
              icon: Icon(Icons.camera_alt),
              onPressed: _tomarFoto,
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(),
                _crearPrecio(),
                SizedBox(
                  height: 10.0,
                ),
                _crearCategoria(),
                _crearDisponible(),
                _crearBoton(),
              ],
            ),
          ),
        )));
  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(labelText: 'Producto'),
      onSaved: (value) => producto.titulo = value,
      validator: (value) {
        if (value.length < 3) {
          return 'Ingrese el nombre del producto';
        } else {
          return null;
        }
      },
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: 'Valor'),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {
        if (utils.esNumero(value)) {
          return null;
        } else {
          return 'Sólo números';
        }
      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
        value: producto.disponible,
        title: Text('Disponible'),
        activeColor: Colors.redAccent,
        onChanged: (value) => setState(() {
              producto.disponible = value;
            }));
  }

  Widget _crearBoton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      color: Colors.redAccent,
      textColor: Colors.white,
      label: Text('Agregar'),
      icon: Icon(Icons.save_alt),
      onPressed: (_guardando) ? null : _submit,
    );
  }

  Widget _crearCategoria() {
    return Row(
      children: <Widget>[
        Text('Categoria'),
        //Icon(Icons.select_all),
        SizedBox(
          width: 30.0,
        ),
        Expanded(
          child: DropdownButton(
              value: producto.categoria,
              items: [
                DropdownMenuItem(
                  child: Text("Comida"),
                  value: 1,
                ),
                DropdownMenuItem(
                  child: Text("Bebida"),
                  value: 2,
                ),
                DropdownMenuItem(
                  child: Text("Aperitivo"),
                  value: 3,
                ),
                DropdownMenuItem(
                  child: Text("Licor"),
                  value: 4,
                ),
              ],
              onChanged: (value) {
                setState(() {
                  producto.categoria = value;
                });
              }),
        )
      ],
    );
  }

  void _submit() async {
    if (!formKey.currentState.validate()) return;

    formKey.currentState.save();

    setState(() {
      _guardando = true;
    });

    if (foto != null) {
      producto.fotoUrl = await productosBloc.subirFoto(foto);
    }

    if (producto.id == null) {
      productosBloc.agregarProducto(producto);
    } else {
      productosBloc.editarProducto(producto);
    }

    mostrarSnakbar('¡Registro Guardado!');
  }

  void mostrarSnakbar(String mensaje) {
    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),
    );
    scaffoldfKey.currentState.showSnackBar(snackbar);

    Navigator.pop(context);
  }

  Widget _mostrarFoto() {
    if (producto.fotoUrl != null) {
      return FadeInImage(
        placeholder: AssetImage('assets/log.gif'),
        image: NetworkImage(producto.fotoUrl),
        height: 300.0,
        fit: BoxFit.contain,
      );
    } else {
      return Image(
        image: AssetImage(foto?.path ?? 'assets/image2.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  _seleccionarFoto() async {
    _procesarImagen(ImageSource.gallery);
  }

  _tomarFoto() async {
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource origen) async {
    foto = await ImagePicker.pickImage(source: origen);
    if (foto != null) {
      producto.fotoUrl = null;
    }

    setState(() {});
  }
}
