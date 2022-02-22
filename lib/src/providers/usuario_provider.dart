import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider {
  final String _apiToken = 'XxjbA2i2ksU4byJg00Dvc1XUhqqlBX+Jk48kijKEOK0=';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async {
    //String pwsha;
    //var bytes = utf8.encode(password);

    //var digest = sha512.convert(bytes);

    final authData = {
      'username': email,
      'password': password,
      //'token': _apiToken,
    };

    final resp = await http.post(
        Uri.parse('http://funcionarios.ubo.cl/api/login'),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
        body: json.encode(authData));
    print(resp.body);
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    //print(decodedResp);

    if (decodedResp.containsKey('status')) {
      if (decodedResp['status'] == 404) {
        return {'ok': false, 'mensaje': decodedResp['mensaje']};
      }

      if (decodedResp['status'] == 200) {
        _prefs.nombre = decodedResp['nombre'];
        _prefs.identificacion = decodedResp['identificacion'];
        _prefs.appaterno = decodedResp['apellido_paterno'];
        _prefs.apmaterno = decodedResp['apellido_materno'];
        //_prefs.carrera = decodedResp['body']['carrera'];
        //_prefs.facultad = decodedResp['body']['facultad'];
        //_prefs.codfacultad = decodedResp['body']['cod_facultad'];
        _prefs.correo = decodedResp['correo'];
        _prefs.imagen = decodedResp['imagen'];
        _prefs.usuario = email;
        // _prefs.sessionid = decodedResp['session_id'];
        //_prefs.grado = decodedResp['body']['grado'];
        //_prefs.password = decodedResp['body']['password'];
        _prefs.funcionario_activo = decodedResp['funcionario_activo'];
        _prefs.controlacceso = decodedResp['control_acceso'];
        _prefs.cargo = decodedResp['cargoFuncionario'];
        _prefs.tipofuncionario = decodedResp['tipoFuncionario'];

        /*switch (_prefs.codfacultad) {
          case 'ING':
            {
              _prefs.imagenCredencial = 'assets/img/credencial/fingenieria.jpg';
            }
            break;

          case 'HUM':
            {
              _prefs.imagenCredencial = 'assets/img/credencial/feducacion.jpg';
            }
            break;

          case 'SDR':
            {
              _prefs.imagenCredencial = 'assets/img/credencial/fsalud.jpg';
            }
            //statements;
            break;

          case 'CJ':
            {
              _prefs.imagenCredencial = 'assets/img/credencial/fsociales.jpg';
            }
            //statements;
            break;

          case 'CM':
            {
              _prefs.imagenCredencial = 'assets/img/credencial/fmedicas.jpg';
            }
            //statements;
            break;

          case 'POST':
            {
              _prefs.imagenCredencial = 'assets/img/credencial/fpostgrados.jpg';
            }
            //statements;
            break;
        }*/

        /* if (_prefs.codfacultad == 'ING') {
          _prefs.imagenCredencial = 'assets/img/credencial/fingenieria.jpg';
        }*/

        return {'ok': true, 'mensaje': decodedResp['mensaje']};
      }

      //_prefs.token = decodedResp['idToken'];
    }
    return {'ok': false, 'mensaje': 'retorno inválido'};
  }

  uploadImage(String path) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse('http://funcionarios.ubo.cl/api/cambiar_imagen'));
    request.fields['identificacion'] = _prefs.identificacion;
    request.files.add(await http.MultipartFile.fromPath("imagen", path));
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
    // print(response.body);
  }

  getPatentes() async {
    // Uri.http(authority, unencodedPath)
    final resp = await http.get(
      Uri.parse('http://funcionarios.ubo.cl/api/funcionario/patentes')
          .replace(queryParameters: {"identificacion": _prefs.identificacion}),
      headers: {'Content-Type': 'application/json;charset=UTF-8'},
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    return decodedResp;
  }

  setPatentes(patente1, patente2) async {
    // Uri.http(authority, unencodedPath)
    final resp = await http.get(
      Uri.parse('http://funcionarios.ubo.cl/api/funcionario/patentes/insert')
          .replace(queryParameters: {
        "identificacion": _prefs.identificacion,
        "patente1": patente1,
        "patente2": patente2
      }),
      headers: {'Content-Type': 'application/json;charset=UTF-8'},
    );
    print(resp.body);
    if (resp.statusCode != 200) {
      return false;
    }
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    return true;
  }
}