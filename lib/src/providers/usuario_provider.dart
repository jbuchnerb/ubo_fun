import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:ubo_fun/assets/Constants.dart';

import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class UsuarioProvider {
  final String _apiToken = 'XxjbA2i2ksU4byJg00Dvc1XUhqqlBX+Jk48kijKEOK0=';
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> login(String email, String password) async {
    //String pwsha;
    //var bytes = utf8.encode(password);

    //var digest = sha512.convert(bytes);
    password = md5.convert(utf8.encode(password)).toString();
    final authData = {
      'username': email,
      'password': password,
      //'token': _apiToken,
    };
    log(authData.toString());
    final resp = await http.post(Uri.parse('${Constants.API_URL}api/login'),
        headers: {
          'Content-Type': 'application/json;charset=UTF-8',
          "Access-Control-Allow-Origin": "*"
        },
        body: json.encode(authData));
    // print(resp.body);
    // print(resp.statusCode);
    Map<String, dynamic> decodedResp;
    try {
      decodedResp = json.decode(resp.body);
      log(decodedResp.toString());
    } catch (e) {
      return {
        'ok': false,
        'mensaje': 'Ha ocurrido un error mientras se intentaba iniciar sesión'
      };
    }

    // print(decodedResp['status'] == '404');
    // print(decodedResp);
    print("aquí!");
    print(decodedResp);

    if (decodedResp.containsKey('status')) {
      if (decodedResp['status'] != 200) {
        return {'ok': false, 'mensaje': decodedResp['message']};
      }

      if (decodedResp['status'] == 200) {
        _prefs.nombre = decodedResp['nombre'] ?? '';
        _prefs.identificacion = decodedResp['identificacion'] ?? '';
        _prefs.appaterno = decodedResp['apellido_paterno'] ?? '';
        _prefs.apmaterno = decodedResp['apellido_materno'] ?? '';
        //_prefs.carrera = decodedResp['body']['carrera'];
        //_prefs.facultad = decodedResp['body']['facultad'];
        //_prefs.codfacultad = decodedResp['body']['cod_facultad'];
        _prefs.correo = decodedResp['correo'] ?? '';
        _prefs.imagen = decodedResp['imagen'] ?? '';
        _prefs.usuario = email;
        // _prefs.sessionid = decodedResp['session_id'];
        //_prefs.grado = decodedResp['body']['grado'];
        //_prefs.password = decodedResp['body']['password'];
        _prefs.funcionario_activo = decodedResp['funcionario_activo'] ?? 0;
        _prefs.controlacceso = decodedResp['control_acceso'] ?? '';
        _prefs.cargo = decodedResp['cargoFuncionario'] ?? '';
        _prefs.tipofuncionario = decodedResp['tipoFuncionario'] ?? '';
        _prefs.idusuario = decodedResp['idusuario'] ?? '';

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

        return {'ok': true, 'mensaje': decodedResp['message']};
      }

      //_prefs.token = decodedResp['idToken'];
    }
    return {'ok': false, 'mensaje': 'retorno inválido'};
  }

  uploadImage(String path) async {
    var request = http.MultipartRequest(
        "POST", Uri.parse('${Constants.API_URL}api/cambiar_imagen'));
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
      Uri.parse('${Constants.API_URL}api/funcionario/patentes')
          .replace(queryParameters: {"identificacion": _prefs.identificacion}),
      headers: {'Content-Type': 'application/json;charset=UTF-8'},
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    return decodedResp;
  }

  setPatentes(patente1, patente2) async {
    // Uri.http(authority, unencodedPath)
    final resp = await http.get(
      Uri.parse('${Constants.API_URL}api/funcionario/patentes/insert')
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

  chagePassword(clave_actual, clave_nueva, clave_nueva_conf) async {
    // Uri.http(authority, unencodedPath)
    final resp = await http.post(
      Uri.parse('${Constants.API_URL}api/cambiar_contrasena'),
      body: json.encode({
        "identificacion": _prefs.identificacion,
        "clave_actual": clave_actual,
        "clave_nueva": clave_nueva,
        "clave_nueva_conf": clave_nueva_conf,
      }),
      headers: {'Content-Type': 'application/json;charset=UTF-8'},
    );
    print(resp.body);
    if (resp.statusCode != 200 && resp.statusCode != 404) {
      return {
        "status": "500",
        "message": "Ha ocurrido un error, favor vuelva a intentarlo."
      };
    }
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    return decodedResp;
  }
}
