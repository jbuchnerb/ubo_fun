import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:ubo_fun/assets/Constants.dart';

class Functions {
  static encrypt(String value) {
    final key = Key.fromUtf8(Constants.PRIVATE_KEY);
    final iv = IV.fromLength(16);
    final crypter = Encrypter(AES(key));
    return crypter.encrypt(value, iv: iv).base64;
  }

  static decrypt(String value) {
    final key = Key.fromUtf8(Constants.PRIVATE_KEY);
    final iv = IV.fromLength(16);
    final crypter = Encrypter(AES(key));

    return crypter.decrypt64(value, iv: iv);
  }

  static encryptJson(Map<String, Object> json) {
    return Functions.encrypt(jsonEncode(json));
  }

  static decryptJson(String cryptedJson) {
    return jsonDecode(Functions.decrypt(cryptedJson));
  }
}
