import 'dart:ui';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:ubo_fun/src/providers/qrscan_provider.dart';
import 'package:ubo_fun/src/providers/qrscan_alumnos_provider.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:ubo_dvu/src/pages/bienestar/cuidadoyproteccion.page.dart';

class QrScanPage extends StatefulWidget {
  static final String routeName = 'qrscan';
  const QrScanPage({Key? key}) : super(key: key);

  @override
  _QrScanPageState createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  String _scanBarcode = 'Unknown';

  final _qrscanprovider = QrscanProvider();
  final _qrscanalumnosprovider = QrscanAlumnosProvider();

  String identificacion = '';
  String nombre = '';
  String? apellidos = '';
  int? funcionario_activo = 0;
  String tipofuncionario = '';
  String cargofuncionario = '';
  String correo = '';
  String patente1 = '';
  String patente2 = '';
  ImageProvider imagen = Image.asset("assets/img/perfil_imagen.png").image;
  String? imagenstring = '';
  String tipoScanner = '';
  String scarrera = '';
  String sestadoalumno = '';
  String? fechamatricula = '';
  String? imagenCredencial = '';
  //Uint8List _bytes;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _launchInBrowser(String url) async {
    if (!await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    )) {
      throw 'Could not launch $url';
    }
  }

  Future<void> startBarcodeScanStream(String ScanType) async {
    tipoScanner = ScanType;
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.BARCODE)!
        .listen((barcode) => print(barcode));
  }

  Future<void> startQrScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666', 'Cancel', true, ScanMode.QR)!
        .listen((barcode) => print(barcode));
  }

  Future<void> scanQR(String ScanType) async {
    String barcodeScanRes;
    tipoScanner = ScanType;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      //print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;

      identificacion = '';
      nombre = '';
      apellidos = '';
      funcionario_activo = 0;
      tipofuncionario = '';
      cargofuncionario = '';
      correo = '';
      patente1 = '';
      patente2 = '';
      imagen = Image.asset("assets/img/perfil_imagen.png").image;
      imagenstring = '';
      // tipoScanner = '';
      scarrera = '';
      imagenCredencial = '';
      sestadoalumno = '';
      fechamatricula = '';
      //_scanBarcode = '165575288\$';
      //barcodeScanRes='asdasd';

      switch (tipoScanner) {
        case 'QrScanFuncionarios':
          getDatosFuncionario(_scanBarcode);
          break;
        case 'QrScanAlumnos':
          //print('alumnos');
          getDatosAlumno(_scanBarcode);
          break;
      }
    });
  }

  Future<bool> getDatosFuncionario(identificacion) async {
    AlertDialog dialog = AlertDialog(
      title: Text("Buscando..."),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
    Map<String, dynamic> decodedResp =
        await _qrscanprovider.getDatosFuncionario(identificacion);

    if (decodedResp['ok'] == false) {
      Navigator.of(context).pop();
      // _formularioblanco(context);

      AlertDialog dialog = AlertDialog(
        title: Text("Funcionario no encontrado"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"))
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
      );

      return false;
    }

    setState(() {
      identificacion = decodedResp['identificacion'];
      nombre = 'Nombre:' + decodedResp['nombre'];
      apellidos = decodedResp['apellido_paterno'] +
          ' ' +
          decodedResp['apellido_materno'];
      //apellido_materno = decodedResp['apellido_materno'];
      funcionario_activo = decodedResp['funcionario_activo'];
      tipofuncionario = 'Tipo funcionario: ' + decodedResp['tipoFuncionario'];
      cargofuncionario = 'Cargo: ' + decodedResp['cargoFuncionario'];
      imagenstring = decodedResp['imagen'] ?? '';
      correo = 'Correo: ' + (decodedResp['correo'] ?? '');
      patente1 = 'Patente 1: ' + (decodedResp['patente1'] ?? 'Sin patente');
      patente2 = 'Patente 2: ' + (decodedResp['patente2'] ?? 'Sin patente');

      if (imagenstring != "") {
        Uint8List _bytes = base64.decode(imagenstring!);
        imagen = Image.memory(
          _bytes,
        ).image;
      } else {
        imagen = Image.asset("assets/img/perfil_imagen.png").image;
      }
      //imagen = decodedResp['imagen'];

      //_tipoFormulario(context,tipoScanner);
    });
    Navigator.of(context).pop();
    return true;
  }

  Future<bool> getDatosAlumno(identificacion) async {
    AlertDialog dialog = AlertDialog(
      title: Text("Buscando..."),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
    Map<String, dynamic> decodedResp =
        await _qrscanalumnosprovider.getDatosAlumno(identificacion);

    if (decodedResp['ok'] == false) {
      Navigator.of(context).pop();

      AlertDialog dialog = AlertDialog(
        title: Text("Alumno no encontrado"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"))
        ],
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return dialog;
        },
      );
      return false;
    }

    setState(() {
      identificacion = decodedResp['rut'];

      final facultad = decodedResp['cod_facultad'];
      this.imagenCredencial = _imagenCredencial(facultad);

      nombre = 'Nombre:' + decodedResp['nombre'];
      //apellidos = decodedResp['apellido_paterno']+' '+decodedResp['apellido_materno'];;
      //apellido_materno = decodedResp['apellido_materno'];
      //funcionario_activo = decodedResp['funcionario_activo'];
      scarrera = 'Carrera: ' + decodedResp['nombre_carrera'];
      //cargofuncionario = 'Cargo: '+decodedResp['cargoFuncionario'];
      sestadoalumno = 'Estado Alumno: ' + decodedResp['estado'];
      imagenstring = decodedResp['imagen'];
      fechamatricula = decodedResp['fecha_matricula'];
      //correo = 'Correo: '+decodedResp['correo'];

      if (imagenstring != null) {
        Uint8List _bytes = base64.decode(imagenstring!);
        imagen = Image.memory(
          _bytes,
        ).image;
      } else {
        imagen = Image.asset("assets/img/perfil_imagen.png").image;
      }

      //imagen = decodedResp['imagen'];
      //print(tipoScanner);
      //_tipoFormulario(context,tipoScanner);
    });

    Navigator.of(context).pop();
    return true;
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      //print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
      //_scanBarcode='165575288';
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imgperfil;
    imgperfil = Image.asset("assets/img/perfil_imagen.png").image;
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
        body: /*Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[generateBotones(context)],
      )
      )*/
            Container(
                child: Table(
          //border: TableBorder.all(),
          columnWidths: const <int, TableColumnWidth>{
            //0: IntrinsicColumnWidth(),
            1: FlexColumnWidth(1.5),
            2: FixedColumnWidth(64),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(children: <Widget>[
              Column(
                children: _tipoFormulario(context, tipoScanner),
              ),
            ]),
            TableRow(children: <Widget>[
              Column(
                children: <Widget>[generateBotones(context)],
              )
            ]), /*
        TableRow(

          children: <Widget>[generateBotones(context)],
        ),*/
          ],
        )));
  }

  /* generateScanBarcode(context){
    ImageProvider imgperfil;
    Size size = MediaQuery.of(context).size;
      imgperfil = Image.asset("assets/img/perfil_imagen.png").image;

    return Container(
                  //alignment: Alignment.center,
                  child:Column(children: <Widget>[
                        ElevatedButton(
                            onPressed: () => scanBarcodeNormal(),
                            child: Text('Start barcode scan')),
                        ElevatedButton(
                            onPressed: () => scanQR(),
                            child: Text('Start QR scan')),
                        ElevatedButton(
                            onPressed: () => startBarcodeScanStream(),
                            child: Text('Start barcode scan stream')),
                        Text('Scan result : $_scanBarcode\n',
                            style: TextStyle(fontSize: 20))
                      ]
                      )
    );
  }
*/

  generateBotones(context) {
    ImageProvider imgperfil;
    Size size = MediaQuery.of(context).size;
    imgperfil = Image.asset("assets/img/perfil_imagen.png").image;

    return Container(
        //width: size.width * 1,
        height: size.height * 0.3,
        /*decoration: BoxDecoration(
        color: Color.fromRGBO(8, 54, 130, 1.0),*/
        // borderRadius: BorderRadius.circular(12),
        /*image: DecorationImage(
            image: imgperfil,
            fit: BoxFit.fill),*/
        /*),*/
        child: Center(
          child: Container(
              // height: size.height * 1,
              child: GridView.count(
            primary: false,
            //padding: const EdgeInsets.all(3),
            crossAxisSpacing: 1,
            mainAxisSpacing: 0,
            crossAxisCount: 3,
            children: <Widget>[
              Container(
                //padding: const EdgeInsets.all(8),
                child: _crearBotonRedondeado(
                    Color.fromRGBO(8, 54, 130, 1.0),
                    Icons.home_repair_service_sharp,
                    'Funcionarios',
                    'QrScanFuncionarios'),
                color: Colors.transparent,
              ),
              Container(
                //padding: const EdgeInsets.all(8),
                child: _crearBotonRedondeado(Color.fromRGBO(8, 54, 130, 1.0),
                    Icons.cast_for_education_sharp, 'Alumnos', 'QrScanAlumnos'),
                color: Colors.transparent,
              ),
             /* Container(
                ///padding: const EdgeInsets.all(1),
                child: _crearBotonRedondeado(Color.fromRGBO(8, 54, 130, 1.0),
                    Icons.sell, 'Encomienda', ''),
                color: Colors.transparent,
              ),*/
              Container(
                //padding: const EdgeInsets.all(1),
                child: _crearBotonRedondeado(Color.fromRGBO(8, 54, 130, 1.0),
                    Icons.health_and_safety, 'mevacuno.cl', 'MeVacuno'),
                color: Colors.transparent,
              ),
            ],
          )),
        ));
  }

  _tipoFormulario(context, Scantype) {
    switch (Scantype) {
      //   case 'QrScanFuncionarios':
      //     _crearFormulario(context);
      //     break;

      case '':
        return _formularioblanco(context);
        break;
      case 'QrScanAlumnos':
        return _crearFormularioAlumno(context);
        break;
      case 'QrScanFuncionarios':
        return _crearFormulario(context);
        break;
    }
    // setState(() {
    // switch (Scantype) {
    //   case 'QrScanFuncionarios':
    //     _crearFormulario(context);
    //     break;
    //   case 'QrScanAlumnos':
    //     _crearFormularioAlumno(context);
    //     break;
    //   case '':
    //     return _formularioblanco(context);
    //     break;
    //   default:
    //     return _formularioblanco(context);
    //   };

    // });
  }

  _formularioblanco(context) {
    ImageProvider imgperfil;
    Size size = MediaQuery.of(context).size;
    imgperfil = Image.asset("assets/img/perfil_imagen.png").image;
    return <Widget>[
      Container(
        height: size.height * 0.70,
        margin: EdgeInsets.all(5),
        //width: size.width * 1,
        //height: size.height * 1,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
          /*image: DecorationImage(
            //image: Image.asset('${_prefs.imagenCredencial}').image,
            fit: BoxFit.fill),*/
        ),
        //),
        child: Center(
            child: Container(
                child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.03),
            CircleAvatar(
              radius: size.width * 0.2,

              backgroundColor: Colors.white,

              backgroundImage: imgperfil,
              // child: Image.asset('assets/img/profile.png'),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Text(
              '',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              '',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              '',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              '',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              '',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
          ],
        ))),
      )
    ];
  }

  _crearFormulario(context) {
    //bool ScanReturn){

    Size size = MediaQuery.of(context).size;
    //if(ScanReturn==true){w
    DecorationImage? decorador;
    if (nombre != '') {
      decorador = DecorationImage(
          image: Image.asset('assets/img/credencial/crede1.png').image,
          fit: BoxFit.fill);
    }
    // assets/img/credencial/crede1.png
    return <Widget>[
      Container(
        height: size.height * 0.70,
        margin: EdgeInsets.all(5),
        //width: size.width * 1,
        //height: size.height * 1,
        decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(20),
            image: decorador),
        child: Center(
            child: Container(
                child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.03),
            CircleAvatar(
              radius: size.width * 0.2,

              backgroundColor: Colors.white,

              backgroundImage: imagen,
              // child: Image.asset('assets/img/profile.png'),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Text(
              '$nombre',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              '$apellidos',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              '$cargofuncionario',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              '$tipofuncionario',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              '$correo',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              '$patente1',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              '$patente2',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
          ],
        ))),
      )
    ];
  }

  _crearFormularioAlumno(
    context,
  ) {
    //bool ScanReturn){

    /*identificacion = decodedResp['rut'];
      nombre = 'Nombre:'+decodedResp['nombre'];
      //apellidos = decodedResp['apellido_paterno']+' '+decodedResp['apellido_materno'];;
      //apellido_materno = decodedResp['apellido_materno'];
      //funcionario_activo = decodedResp['funcionario_activo'];
      scarrera = 'Carrera: '+decodedResp['nombre_carrera'];
      //cargofuncionario = 'Cargo: '+decodedResp['cargoFuncionario'];
      sestadoalumno = 'Estado Alumno: '+decodedResp['estado'];
      imagenstring = decodedResp['imagen'];*/

    Size size = MediaQuery.of(context).size;
    //if(ScanReturn==true){w
    DecorationImage? decorador;
    if (this.imagenCredencial != '') {
      decorador = DecorationImage(
          image: Image.asset('${this.imagenCredencial}').image,
          fit: BoxFit.fill);
    }
    return <Widget>[
      Container(
        height: size.height * 0.70,
        margin: EdgeInsets.all(5),
        //width: size.width * 1,
        //height: size.height * 1,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(20),
          image: decorador,
        ),
        child: Center(
            child: Container(
                child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.10),
            CircleAvatar(
              radius: size.width * 0.2,

              backgroundColor: Colors.white,
              // backgroundColor: Color.fromRGBO(8, 54, 130, 1.0),

              backgroundImage: imagen,
              // child: Image.asset('assets/img/profile.png'),
            ),
            SizedBox(
              height: size.height * 0.05,
            ),
            Text(
              '$nombre',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Colors.white),
              // .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            /*Text(
            '$apellidos',
            style: Theme.of(context)
                .textTheme
                .headline6
                .apply(color: Colors.white),
                textAlign: TextAlign.center,
          ),
          SizedBox(
            height: size.height * 0.01,
          ),*/
            Text(
              '$scarrera',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Colors.white),
              // .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              '$sestadoalumno',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Colors.white),
              // .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text(
              '$fechamatricula',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .apply(color: Colors.white),
              // .apply(color: Color.fromRGBO(8, 54, 130, 1.0)),
              textAlign: TextAlign.center,
            ),
          ],
        ))),
      )
    ];
  }

  Widget _crearBotonRedondeado(
      Color color, IconData icono, String texto, String ScanType) {
    Size size = MediaQuery.of(context).size;
    String enlace = 'https://scanmevacuno.gob.cl';

    return GestureDetector(
      onTap: () {
        if (ScanType == 'QrScanFuncionarios' || ScanType == 'QrScanAlumnos') {
          scanQR(ScanType);
        }
        ;
        if (ScanType == 'MeVacuno') {
          _launchInBrowser(enlace);

          /* () async { 
                            
                           if (await canLaunch(enlace)) {
                              await launch(enlace, forceSafariVC: false,);
                            } else {
                              throw 'No fue posible abrir el enlace $enlace';
                            }*/
          //  },
        }
        ;
        /*switch(ScanType){
          case 'QrScanFuncionario': 
            startBarcodeScanStream(ScanType);
            break;
          case 'QrScanAlumno':
            startBarcodeScanStream(ScanType);
            break;*/
        // }
      },
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            //height: 10000,
            margin: EdgeInsets.all(1.0),
            decoration: BoxDecoration(
                color: Color.fromRGBO(66, 129, 237, 0.2),
                borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //SizedBox(height: 5.0),
                CircleAvatar(
                  backgroundColor: color,
                  radius: size.width * 0.09,
                  child:
                      Icon(icono, color: Colors.white, size: size.width * 0.08),
                ),
                Text(texto,
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(color: color, fontWeight: FontWeight.bold)),
                //SizedBox(height: 5.0)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _imagenCredencial(facultad) {
    String imagen = '';
    switch (facultad) {
      case 'ING':
        {
          imagen = 'assets/img/credencial/fingenieria.jpg';
        }
        break;

      case 'HUM':
        {
          imagen = 'assets/img/credencial/feducacion.jpg';
        }
        break;

      case 'SDR':
        {
          imagen = 'assets/img/credencial/fsalud.jpg';
        }
        //statements;
        break;

      case 'CJ':
        {
          imagen = 'assets/img/credencial/fsociales.png';
        }
        //statements;
        break;

      case 'CM':
        {
          imagen = 'assets/img/credencial/fmedicas.jpg';
        }
        //statements;
        break;

      case 'POST':
        {
          imagen = 'assets/img/credencial/fpostgrados.jpg';
        }
        //statements;
        break;
    }

    return imagen;
  }
}
