import 'dart:developer';
import 'dart:html';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
//import 'package:qr/qr.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ubo_fun/assets/Constants.dart';
import 'package:ubo_fun/assets/Functions.dart';
import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';
//import 'package:ubo_dvu/src/providers/usuario_provider.dart';

class CredentialAccesoPage extends StatelessWidget {
  static final String routeName = 'credential_acceso';
  final _prefs = PreferenciasUsuario();

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
          child: ListView(children: [generateCredencial(context)]),
        ));
  }

  generateCredencial(context) {
    ImageProvider imgperfil;
    Size size = MediaQuery.of(context).size;
    TextStyle styletext =
        TextStyle(fontSize: 23, color: Color.fromRGBO(8, 54, 130, 1.0));
    if (_prefs.imagen != "") {
      Uint8List _bytes = base64.decode('${_prefs.imagen}');
      imgperfil = Image.memory(
        _bytes,
        //width: size.width * 0.45,
      ).image;
    } else {
      imgperfil = Image.asset("assets/img/perfil_imagen.png").image;
    }

    return Container(
      width: size.width * 0.95,
      height: size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.indigo[100],
        image: DecorationImage(
            image: Image.asset('assets/img/credencial/crede1.png').image,
            fit: BoxFit.fill),
      ),
      child: Center(
          child: Container(
              child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: size.height * 0.07,
          ),
          Container(
              width: size.width * 0.40,
              height: size.height * 0.20,
              decoration: new BoxDecoration(
                  border: Border.all(
                      width: size.height * 0.007,
                      color: Color.fromRGBO(8, 54, 130, 1.0)),
                  //shape: BoxShape.circle,
                  image:
                      new DecorationImage(fit: BoxFit.fill, image: imgperfil))),
          SizedBox(
            height: size.height * 0.05,
          ),
          Text(_prefs.nombre,
              style:
                  styletext /*Theme.of(context)
                .textTheme
                .headline6
                .apply( color: Color.fromRGBO(8, 54, 130, 1.0)),
                textAlign: TextAlign.center,*/
              ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(_prefs.appaterno + ' ' + _prefs.apmaterno, style: styletext),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(_prefs.identificacion, style: styletext),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(_prefs.correo, style: styletext),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(
            _prefs.cargo,
            style: styletext,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            generateQr(size),
          ])
        ],
      ))),
    );
  }

  generateCard(context, {required title, required text}) {
    //Size size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset('${_prefs.imagenCredencial}'),
          ),
        ],
      ),
    );
  }

  generateQr(Size size) {
    //identificacion, idusuario, hora y hash
    final dateNow = DateTime.now();
    final unixDate = dateNow.millisecondsSinceEpoch;
    final json = {
      "identificacion": _prefs.identificacion,
      "idusuario": _prefs.idusuario,
      "dt": unixDate,
      "hash": Functions.makeHash(unixDate),
    };

    final crypted = Functions.encryptJson(json);

    return QrImage(
      data: crypted,
      version: QrVersions.auto,
      size: size.height * 0.17,
      gapless: false,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      /*embeddedImage: AssetImage("assets/img/logo_ubo.jpg"),
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: Size(30, 15),
      ),*/
    );
  }

  Widget verticalText(String text) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        RotatedBox(
            quarterTurns: 1,
            child: Text(
              text,
              style: TextStyle(color: Colors.black, fontSize: 20),
              //textAlign: TextAlign.right,
            )),
      ],
    );
  }
}
