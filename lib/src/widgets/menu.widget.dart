import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ubo_fun/src/pages/credential2.page.dart';
import 'package:ubo_fun/src/pages/credential_acceso.page.dart';
import 'package:ubo_fun/src/pages/home.page.dart';
import 'package:ubo_fun/src/pages/qrscan.page.dart';
import 'package:ubo_fun/src/pages/news.page.dart';
import 'package:ubo_fun/src/pages/login.page.dart';
import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';

class MenuWidget extends StatefulWidget {
  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  final _prefs = new PreferenciasUsuario();

  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ImageProvider imgperfil;
    //print("Imagen: ${_prefs.imagen}");
    /* if (_prefs.imagen != "") {
      //print('1');
      Uint8List _bytes = base64.decode('${_prefs.imagen}');
      imgperfil = Image.memory(_bytes).image;
    } else {*/
    //print('2');
    imgperfil = Image.asset("assets/img/perfil_imagen.png").image;
    // }

    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: size.height * 0.35,
            child: DrawerHeader(
              child: Column(
                //mainAxisSize: MainAxisSize.max,

                children: [
                  Container(
                    // color: Colors.white,
                    // child: Image(
                    //   image: AssetImage("assets/img/logo_ubo.png"),
                    // ),
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.white,

                      backgroundImage: imgperfil,
                      // child: Image.asset('assets/img/profile.png'),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Christian',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .apply(color: Colors.blue[900]),
                  ),
                  Text(
                    'León',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .apply(color: Colors.blue[900]),
                  ),
                  Text(
                    'Jefe de seguridad',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .apply(color: Colors.blue[900]),
                  )
                ],
              ),
              // decoration: BoxDecoration(
              //   color: Colors.blue,
              // ),
            ),
          ),
          ListTile(
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, HomePage.routeName);
            },
          ),
          ListTile(
            title: Text('Noticias'),
            onTap: () {
              Navigator.pushReplacementNamed(context, NewsPage.routeName);
            },
          ),
          ListTile(
            title: Text('Credencial UBO'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushReplacementNamed(
                  context, Credential2Page.routeName);
            },
          ),
          ListTile(
            title: Text('Credencial Acceso'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushReplacementNamed(
                  context, CredentialAccesoPage.routeName);
            },
          ),
          ListTile(
            title: Text('Escanear QR'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushReplacementNamed(context, QrScanPage.routeName);
            },
          ),
          /*ListTile(
            title: Text('Bienestar y calidad de vida'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushReplacementNamed(context, BienestarPage.routeName);
            },
          ),*/
          //),
          /*ListTile(
            title: Text('Beneficios y cuidado integral'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushReplacementNamed(context, BeneficiosPage.routeName);
            },
          ),*/
          /*ListTile(
            title: Text('Servicios y atención estudiantil'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushReplacementNamed(context, ServiciosPage.routeName);
            },
          ),*/
          SizedBox(
            height: size.height * 0.09,
          ),
          ListTile(
            title: Text('Cerrar sesión'),
            onTap: () {
              Navigator.pushReplacementNamed(context, LoginPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
