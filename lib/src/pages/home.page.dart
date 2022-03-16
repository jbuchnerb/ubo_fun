import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:ubo_fun/src/pages/login.page.dart';
import 'package:ubo_fun/src/pages/news.page.dart';
import 'package:ubo_fun/src/pages/password.page.dart';
import 'package:ubo_fun/src/pages/patentes.page.dart';
import 'package:ubo_fun/src/pages/profile_image.page.dart';
import 'package:ubo_fun/src/pages/qrscan.page.dart';
import 'package:ubo_fun/src/pages/credential2.page.dart';
import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';

class HomePage extends StatefulWidget {
  static final String routeName = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _prefs = new PreferenciasUsuario();

  Widget build(BuildContext context) {
    //Size size = MediaQuery.of(context).size;
    ImageProvider imgperfil;
    _prefs.ultimaPagina = HomePage.routeName;
    imgperfil = Image.asset("assets/img/perfil_imagen.png").image;
    return Scaffold(
        //backgroundColor: Image.asset('assets/img/perfil_imagen.png').color,
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/img/fondo-appv6.png"),
                    fit: BoxFit.fill)),
            child: Table(
              //border: TableBorder.all(),
              columnWidths: const <int, TableColumnWidth>{
                //0: IntrinsicColumnWidth(),
                1: FlexColumnWidth(1.5),
                2: FixedColumnWidth(64),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: <TableRow>[
                /*TableRow(
          children: <Widget>[

          Container(
            decoration: BoxDecoration(
            image: DecorationImage(image: new AssetImage("assets/img/logo_ubo_white.png"), fit: BoxFit.fill)),
            ),
        ]
        ),*/
                TableRow(
                  children: <Widget>[generateDatosUsuario(context)],
                ),
                TableRow(
                  children: <Widget>[generateBotones(context)],
                ),
              ],
            )));
  }

  generateBotones(context) {
    ImageProvider imgperfil;
    Color bluecolor = Color.fromRGBO(8, 54, 130, 1.0);
    Size size = MediaQuery.of(context).size;
    imgperfil = Image.asset("assets/img/perfil_imagen.png").image;

    return Container(
        //width: size.width * 1,
        height: size.height * 0.5,
        decoration: BoxDecoration(
            color: Colors.transparent //Color.fromRGBO(8, 54, 130, 1.0),
            // borderRadius: BorderRadius.circular(12),
            /*image: DecorationImage(
            image: imgperfil,
            fit: BoxFit.fill),*/
            ),
        child: Center(
          child: Container(
              child: GridView.count(
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 5,
            mainAxisSpacing: 10,
            crossAxisCount: 3,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(3),
                child: _crearBotonRedondeado(bluecolor, Icons.article_outlined,
                    'Noticias', NewsPage.routeName, context),
                color: Colors.transparent,
              ),
              Container(
                padding: const EdgeInsets.all(3),
                child: _crearBotonRedondeado(bluecolor, Icons.badge_outlined,
                    'Credencial', Credential2Page.routeName, context),
                color: Colors.transparent,
              ),
              Container(
                padding: const EdgeInsets.all(3),
                child: _crearBotonRedondeado(
                    bluecolor,
                    Icons.directions_car_outlined,
                    'Patentes',
                    PatentesPage.routeName,
                    context),
                color: Colors.transparent,
              ),
              Container(
                padding: const EdgeInsets.all(3),
                child: _crearBotonRedondeado(bluecolor, Icons.security,
                    'Cambiar Contaseña', PasswordPage.routeName, context),
                color: Colors.transparent,
              ),
              if (_prefs.controlacceso == 1)
                Container(
                  padding: const EdgeInsets.all(3),
                  child: _crearBotonRedondeado(bluecolor, Icons.qr_code_scanner,
                      'Lector', QrScanPage.routeName, context),
                  color: Colors.transparent,
                ),
              Container(
                padding: const EdgeInsets.all(3),
                child: _crearBotonRedondeado(bluecolor, Icons.logout,
                    'Cerrar sesión', LoginPage.routeName, context),
                color: Colors.transparent,
              ),
            ],
          )),
        ));
  }

  generateLogoUBO(context) {
    ImageProvider imgperfil;
    Size size = MediaQuery.of(context).size;
    imgperfil = Image.asset("assets/img/logo_ubo_white.png").image;

    return Container(
        //width: size.width * 1,
        height: size.height * 0.4,
        decoration: BoxDecoration(
          color: Colors.transparent, //Color.fromRGBO(8, 54, 130, 1.0),
          image: DecorationImage(image: imgperfil, fit: BoxFit.contain),
          //borderRadius: BorderRadius.circular(12),
        ));
  }

  generateDatosUsuario(context) {
    ImageProvider imgperfil;
    Size size = MediaQuery.of(context).size;
    if (_prefs.imagen != "") {
      Uint8List _bytes = base64.decode('${_prefs.imagen}');
      imgperfil = Image.memory(
        _bytes,
      ).image;
    } else {
      imgperfil = Image.asset("assets/img/perfil_imagen.png").image;
    }

    return Container(
        //width: size.width * 1,
        height: size.height * 0.5,
        decoration: BoxDecoration(
          color: Colors.transparent, //olor.fromRGBO(8, 54, 130, 1.0),
          //borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Container(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: size.height * 0.05,
                ),
                Container(
                    width: size.width * 0.40,
                    height: size.height * 0.13,
                    decoration: new BoxDecoration(
                        //shape: BoxShape.circle,
                        image: new DecorationImage(
                            fit: BoxFit.fill,
                            image: Image.asset("assets/img/logo_ubo_white.png")
                                .image))),
                SizedBox(
                  height: size.height * 0.03,
                ),
                InkWell(
                  onTap: () {
                    print("here");
                    Navigator.pushNamed(context, ProfileImage.routeName)
                        .then((value) => setState(() {}));
                  },
                  child: CircularPercentIndicator(
                    radius: 90.0,
                    lineWidth: 5.0,
                    animation: true,
                    percent: 0.75,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.green,
                    backgroundColor: Colors.red,
                    center: CircleAvatar(
                        backgroundColor: Colors.amber,
                        radius: 35.0,
                        backgroundImage: imgperfil),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text(
                        _prefs.nombre,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white70,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        _prefs.appaterno + ' ' + _prefs.apmaterno,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.white70,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        _prefs.cargo,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  Widget _crearBotonRedondeado(
      Color color, IconData icono, String texto, String routeName, context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (routeName != '') Navigator.pushNamed(context, routeName);
      },
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            //height: 180.0,
            //margin: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(66, 129, 237, 0.2),
                borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //SizedBox(height: 5.0),
                CircleAvatar(
                  backgroundColor: Colors
                      .transparent, //Color.fromRGBO(66, 129, 237, 0.2),//color,
                  radius: size.height * 0.030,
                  child: Icon(icono,
                      color: Colors.white, size: size.height * 0.07),
                ),
                Text(texto,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white /*color*/,
                        fontWeight: FontWeight.bold)),
                //SizedBox(height: 5.0)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
