import 'dart:convert';
import 'package:http/http.dart' as http;

class QrscanProvider {
  final String _apiToken = 'XxjbA2i2ksU4byJg00Dvc1XUhqqlBX+Jk48kijKEOK0=';

  Future<Map<String, dynamic>> getDatosFuncionario(identificacion) async {
    final authData = {
      //'token': _apiToken,
      'identificacion': identificacion,
    };

    final resp = await http.post(
        Uri.parse('http://funcionarios.ubo.cl/api/getDatosFuncionario'),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
        body: json.encode(authData));
    print(json.encode(authData));

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    //print(decodedResp['nombre']);

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
