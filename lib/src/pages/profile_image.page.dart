import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:ubo_fun/src/providers/usuario_provider.dart';

class ProfileImage extends StatefulWidget {
  static final String routeName = 'profile_image';

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  // const ProfileImage({Key? key}) : super(key: key);
  final _prefs = PreferenciasUsuario();

  final ImagePicker _picker = ImagePicker();

  Image _imagen =
      Image(image: Image.asset("assets/img/perfil_imagen.png").image);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (_prefs.imagen != "") {
      Uint8List _bytes = base64.decode('${_prefs.imagen}');
      _imagen = Image.memory(
        _bytes,
        //width: size.width * 0.45,
      );
    } else {
      _imagen = Image.asset("assets/img/perfil_imagen.png");
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Center(
                child: Text(
              _prefs.nombre + ' ' + _prefs.appaterno + ' ' + _prefs.apmaterno,
              style: Theme.of(context).textTheme.headline5,
            )),
            Center(child: _imagen),
            Center(
              child: TextButton(
                  child: Text(
                    "Editar",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  onPressed: _chooseImage),
            )
          ]),
        ));
  }

  Widget _showImage(context) {
    ImageProvider imgperfil;
    Size size = MediaQuery.of(context).size;
    TextStyle styletext =
        TextStyle(fontSize: 23, color: Color.fromRGBO(8, 54, 130, 1.0));
    if (_prefs.imagen != "") {
      Uint8List _bytes = base64.decode('${_prefs.imagen}');
      _imagen = Image.memory(
        _bytes,
        //width: size.width * 0.45,
      );
    } else {
      _imagen = Image.asset("assets/img/perfil_imagen.png");
    }
    // imagen = Image.asset("assets/img/perfil_imagen.png").image;
    return Center(
      child: _imagen,
    );
  }

  _chooseImage() async {
    print("change Image");
    final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);

    AlertDialog dialog = AlertDialog(
      title: Text("Guardando..."),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
    if (xFile != null) {
      final path = xFile.path;
      final bytes = await File(path).readAsBytes();
      final img64 = base64.encode(bytes);

      final status = await UsuarioProvider().uploadImage(path);
      Navigator.of(context).pop();
      if (status) {
        _prefs.imagen = img64;
        _imagen = Image.memory(bytes);
        setState(() {});
        return;
      } else {
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
    }
  }
}
