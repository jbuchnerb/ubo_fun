import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:ubo_fun/src/providers/usuario_provider.dart';

class PasswordPage extends StatefulWidget {
  static final String routeName = 'password_page';
  const PasswordPage({Key? key}) : super(key: key);

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final _prefs = PreferenciasUsuario();
  bool _actualVisible = true;
  bool _passwordVisible = true;
  bool _confirmVisible = true;

  final _claveActual = TextEditingController();
  final _nuevaClave = TextEditingController();
  final _nuevaClave2 = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _nuevaClave.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // patentes();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(8, 54, 130, 1.0),
          actions: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.transparent),
              margin: EdgeInsets.all(5),
              child: Image.asset("assets/img/logo_ubo_white.png"),
            )
          ],
          // iconTheme: new IconThemeData(color: Colors.black),
        ),
        body: Container(
          margin: EdgeInsets.all(10),
          child: ListView(children: [
            Text(
              "Cambiar Contaseña",
              style: Theme.of(context).textTheme.headline4,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _claveActual,
              obscureText: _actualVisible,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "abc123",
                labelText: "Clave actual",
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _actualVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _actualVisible = !_actualVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _nuevaClave,
              obscureText: _passwordVisible,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "123abc",
                labelText: "Nueva Clave",
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _nuevaClave2,
              obscureText: _confirmVisible,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "123abc",
                labelText: "Confirmar nueva clave",
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _confirmVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _confirmVisible = !_confirmVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: grabarPatentes, child: Text("Guardar"))
          ]),
        ));
  }

  grabarPatentes() async {
    AlertDialog dialog;
    if (_claveActual.text == '') {
      dialog = AlertDialog(
        title: Text("Error"),
        content: Text("Complete los campos"),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
      );
      return;
    }
    if (_nuevaClave.text == '') {
      dialog = AlertDialog(
        title: Text("Error"),
        content: Text("Complete los campos"),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
      );
      return;
    }
    if (_nuevaClave2.text == '') {
      dialog = AlertDialog(
        title: Text("Error"),
        content: Text("Complete los campos"),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
      );
      return;
    }
    if (_nuevaClave.text != _nuevaClave2.text) {
      dialog = AlertDialog(
        title: Text("Error"),
        content: Text("Clave y confirmación no coinciden"),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
      );
      return;
    }

    dialog = AlertDialog(
      title: Text("Guardando..."),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
    // print("grabando patentes");

    final grabar = await UsuarioProvider()
        .chagenPassword(_claveActual.text, _nuevaClave.text, _nuevaClave2.text);
    Navigator.of(context).pop();
    if (!grabar) {
      dialog = AlertDialog(
        title: Text("Error"),
        content: Text("Ha ocurrido un error, favor vuelva a intentarlo."),
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
      );
    }
    dialog = AlertDialog(
      title: Text("Operacion realizada exitosamente"),
      // content: Text(""),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
    _claveActual.text = '';
    _nuevaClave.text = '';
    _nuevaClave2.text = '';
    print(grabar);
  }
}
