import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:ubo_fun/assets/Constants.dart';
import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';

class QrscanProvider {
  final String _apiToken = 'XxjbA2i2ksU4byJg00Dvc1XUhqqlBX+Jk48kijKEOK0=';

  Future<Map<String, dynamic>> getDatosFuncionario(identificacion) async {
    final _prefs = new PreferenciasUsuario();
    final authData = {
      //'token': _apiToken,
      'data': identificacion
    };
    final resp = await http.post(Uri.parse("${Constants.API_URL}api/scanner"),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
        body: json.encode(authData));
    log(resp.body);
    Map<String, dynamic> decodedResp;
    try {
      decodedResp = json.decode(resp.body);
    } catch (e) {
      return {'ok': false, 'mensaje': "Error en la lectura de la credencial"};
    }
    log(decodedResp.toString());
    if (decodedResp.containsKey('status')) {
      if (decodedResp['status'] == 404) {
        return {'ok': false, 'mensaje': decodedResp['mensaje']};
      }

      if (decodedResp['status'] == 200) {
        String nombre;
        // print('2');
        //print(decodedResp[''].toString());
        //_news.noticias = decodedResp['body'];
        //nombre=decodedResp['body']['nombre'];
        //print(decodedResp);

        return decodedResp; //{'ok': true, 'mensaje': decodedResp['mensaje']};
      }

      //_prefs.token = decodedResp['idToken'];
    }
    return {'ok': false, 'mensaje': 'retorno inválido'};
  }
}
