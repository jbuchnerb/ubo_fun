import 'package:flutter/material.dart';
import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:ubo_fun/src/providers/usuario_provider.dart';

class PatentesPage extends StatefulWidget {
  static final String routeName = 'patentes';

  @override
  State<PatentesPage> createState() => _PatentesPageState();
}

class _PatentesPageState extends State<PatentesPage> {
  final _prefs = PreferenciasUsuario();

  final _patente1controller = TextEditingController();
  final _patente2controller = TextEditingController();

  String _patente1 = "";

  String _patente2 = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPatentes();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _patente1controller.dispose();
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
              "Patentes",
              style: Theme.of(context).textTheme.headline4,
            ),
            TextFormField(
              controller: _patente1controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "AAAA22",
                  labelText: "Patente 1"),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _patente2controller,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "AA2022",
                  labelText: "Patente 2"),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: grabarPatentes, child: Text("Guardar"))
            // _generateForm(context)
          ]),
        ));
  }

  _generateForm(BuildContext context) {
    return TextField(
      decoration:
          InputDecoration(border: OutlineInputBorder(), hintText: "Patente1"),
    );
  }

  getPatentes() async {
    final patentes = await UsuarioProvider().getPatentes();
    _patente1controller.text = patentes["result"]["patente1"] ?? '';
    _patente2controller.text = patentes["result"]["patente2"] ?? '';
  }

  grabarPatentes() async {
    AlertDialog dialog = AlertDialog(
      title: Text("Guardando..."),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
    print("grabando patentes");

    final grabar = await UsuarioProvider()
        .setPatentes(_patente1controller.text, _patente2controller.text);
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
  }
}
