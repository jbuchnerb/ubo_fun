import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ubo_fun/assets/Constants.dart';
import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';

class QrscanAlumnosProvider {
  final String _apiToken = 'XxjbA2i2ksU4byJg00Dvc1XUhqqlBX+Jk48kijKEOK0=';

  Future<Map<String, dynamic>> getDatosAlumno(identificacion) async {
    final _prefs = new PreferenciasUsuario();
    final authData = {
      'rut': identificacion,
      // 'idusuario': _prefs.idusuario,
      'idusuario': '1',
      'token': _apiToken,
    };

    final resp = await http.post(
        Uri.parse('${Constants.API_URL}api/getDatosAlumno'),
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

    if (decodedResp.containsKey('status')) {
      if (decodedResp['status'] == 404) {
        return {'ok': false, 'mensaje': decodedResp['mensaje']};
      }

      if (decodedResp['status'] == 200) {
        return decodedResp; //{'ok': true, 'mensaje': decodedResp['mensaje']};
      }
      //_prefs.token = decodedResp['idToken'];
    }
    return {'ok': false, 'mensaje': 'retorno inválido'};
  }
}
