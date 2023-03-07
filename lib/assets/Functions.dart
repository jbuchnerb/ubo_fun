import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as cryptor;
import 'package:flutter/material.dart';
import 'package:ubo_fun/assets/Constants.dart';
import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';

class Functions {
  static String encrypt(String value) {
    final key = cryptor.Key.fromUtf8(Constants.PRIVATE_KEY);
    final iv = cryptor.IV.fromLength(16);
    final crypter =
        cryptor.Encrypter(cryptor.AES(key, mode: cryptor.AESMode.ecb));
    final crypted = crypter.encrypt(value, iv: iv);

    return crypter.encrypt(value, iv: iv).base64;
  }

  static String decrypt(String value) {
    final key = cryptor.Key.fromUtf8(Constants.PRIVATE_KEY);
    final iv = cryptor.IV.fromLength(16);
    final crypter =
        cryptor.Encrypter(cryptor.AES(key, mode: cryptor.AESMode.ecb));
    try {
      return crypter.decrypt64(value, iv: iv);
    } catch (e) {
      return '';
    }
  }

  static String encryptJson(Map<String, dynamic> json) {
    return Functions.encrypt(jsonEncode(json));
  }

  static Map<String, dynamic> decryptJson(String cryptedJson) {
    try {
      return jsonDecode(Functions.decrypt(cryptedJson));
    } catch (e) {
      return {};
    }
  }

  static String makeHash(int unixDate, {identificacion, idusuario}) {
    PreferenciasUsuario _prefs = new PreferenciasUsuario();
    return md5
        .convert(utf8.encode(
            "${identificacion ?? _prefs.identificacion}${idusuario ?? _prefs.idusuario}$unixDate${Constants.PRIVATE_KEY}"))
        .toString();
  }

  static popup(BuildContext context, message, {ok = false}) {
    List<Widget> actions = [];
    if (ok) {
      actions.add(TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("OK")));
    }
    AlertDialog dialog = AlertDialog(
      title: Text(message),
      actions: actions,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
    return false;
  }

  static validateJson(json, args) {
    for (var item in args) {
      if (json[item] == null) {
        return false;
      }
    }
    return true;
  }
}
