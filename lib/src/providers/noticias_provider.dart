import 'dart:convert';
import 'package:ubo_fun/assets/Constants.dart';
import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:ubo_fun/src/noticias_usuario/noticias_usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NoticiasProvider {
  final String _apiToken = 'XxjbA2i2ksU4byJg00Dvc1XUhqqlBX+Jk48kijKEOK0=';
  final _news = new NoticiasUsuario();
  final _prefs = new PreferenciasUsuario();

  Future<Map<String, dynamic>> getNoticias() async {
    print(_prefs.identificacion);
    final authData = {
      'identificacion': _prefs.identificacion,
    };

    final resp = await http.post(Uri.parse('${Constants.API_URL}api/noticia'),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
        body: json.encode(authData));
    print(resp.body);
    print(authData);
    print(resp);
    if (resp.statusCode != 200) {
      return {'ok': false, 'mensaje': "error al procesar la solicitud"};
    }
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('status')) {
      if (decodedResp['status'] == 404) {
        return {'ok': false, 'mensaje': decodedResp['mensaje']};
      }

      if (decodedResp['status'] == 200) {
        // print('2');

        _news.noticias = json.encode(decodedResp['body']);
        //print("2");
        //print(_news.noticias);

        return {'ok': true, 'mensaje': decodedResp['mensaje']};
      }

      //_prefs.token = decodedResp['idToken'];
    }
    return {'ok': false, 'mensaje': 'retorno inválido'};
  }

  Future<Map<String, dynamic>> getReaccionar(int idnoticia) async {
    final authData = {
      'token': _apiToken,
      'rut': '19.979.628-3',
      'session_id': 'bc4c91d7a06813daae087b0c5b4036a6',
      'idnoticia': idnoticia,
    };

    final resp = await http.post(
        Uri.parse('${Constants.API_URL}api/noticias/reaccion'),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
        body: json.encode(authData));
    //print(json.encode(authData));
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    //print(decodedResp);

    if (decodedResp.containsKey('status')) {
      if (decodedResp['status'] == 404) {
        return {'ok': false, 'mensaje': decodedResp['mensaje']};
      }

      if (decodedResp['status'] == 200) {
        return {'ok': true, 'mensaje': decodedResp['mensaje']};
      }
      //_prefs.token = decodedResp['idToken'];
    }
    return {'ok': false, 'mensaje': 'retorno inválido'};
  }

  Future<Map<String, dynamic>> getLectura(int? idnoticia) async {
    final authData = {
      'identificacion': _prefs.identificacion,
      'idnoticia': idnoticia,
    };

    final resp = await http.post(
        Uri.parse('${Constants.API_URL}api/noticia/read'),
        headers: {'Content-Type': 'application/json;charset=UTF-8'},
        body: json.encode(authData));
    //print(json.encode(authData));
    Map<String, dynamic> decodedResp = json.decode(resp.body);

    //print(decodedResp);

    if (decodedResp.containsKey('status')) {
      if (decodedResp['status'] == 404) {
        return {'ok': false, 'mensaje': decodedResp['mensaje']};
      }

      if (decodedResp['status'] == 200) {
        return {'ok': true, 'mensaje': decodedResp['mensaje']};
      }

      //_prefs.token = decodedResp['idToken'];
    }
    return {'ok': false, 'mensaje': 'retorno inválido'};
  }
}
