import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';

class QrscanAlumnosProvider {
  final String _apiToken = 'XxjbA2i2ksU4byJg00Dvc1XUhqqlBX+Jk48kijKEOK0=';

  Future<Map<String, dynamic>> getDatosAlumno(identificacion) async {
    final _prefs = new PreferenciasUsuario();
    final authData = {
      'rut': identificacion,
      'idusuario': _prefs.idusuario,
      'token': _apiToken,
    };

    final resp = await http.post(
        Uri.parse('http://funcionarios.ubo.cl/api/getDatosAlumno'),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
        body: json.encode(authData));
    //print(json.encode(authData));

    // Map<String, dynamic> decodedResp = json.decode(resp.body);
    Map<String, dynamic> decodedResp;
    try {
      decodedResp = json.decode(resp.body);
    } catch (Exception) {
      return {'ok': false, 'mensaje': "Usuario no encontrado"};
    }

    //print(decodedResp);

    if (decodedResp.containsKey('status')) {
      if (decodedResp['status'] == 404) {
        return {'ok': false, 'mensaje': decodedResp['mensaje']};
      }

      if (decodedResp['status'] == 200) {
        //String nombre;
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
