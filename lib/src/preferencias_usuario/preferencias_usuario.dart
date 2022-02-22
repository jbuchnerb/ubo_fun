import 'package:shared_preferences/shared_preferences.dart';

/*
  Recordar instalar el paquete de:
    shared_preferences:

  Inicializar en el main
    final prefs = new PreferenciasUsuario();
    prefs.initPrefs();

*/

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia =
      new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  late SharedPreferences _prefs;

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  clear() async {
    final retorno = await this._prefs.clear();
    return retorno;
  }

  // GET y SET de la última página
  /*get token {
    return _prefs.getString('token') ?? '';
  }

  set token( String value ) {
    _prefs.setString('token', value);
  }*/

  String get identificacion {
    return this._prefs.getString('identificacion') ?? '';
  }

  set identificacion(String value) {
    this._prefs.setString('identificacion', value);
  }

  String get nombre {
    return this._prefs.getString('nombre') ?? '';
  }

  set nombre(String value) {
    this._prefs.setString('nombre', value);
  }

  String get appaterno {
    return this._prefs.getString('appaterno') ?? '';
  }

  set appaterno(String value) {
    this._prefs.setString('appaterno', value);
  }

  String get apmaterno {
    return this._prefs.getString('apmaterno') ?? '';
  }

  set apmaterno(String value) {
    this._prefs.setString('apmaterno', value);
  }

  String get correo {
    return this._prefs.getString('correo') ?? '';
  }

  set correo(String value) {
    this._prefs.setString('correo', value);
  }

  int get funcionario_activo {
    return this._prefs.getInt('funcionario_activo') ?? 0;
  }

  set funcionario_activo(int value) {
    this._prefs.setInt('funcionario_activo', value);
  }

  String get tipofuncionario {
    return this._prefs.getString('tipofuncionario') ?? '';
  }

  set tipofuncionario(String value) {
    this._prefs.setString('tipofuncionario', value);
  }

  String get cargo {
    return this._prefs.getString('cargo') ?? '';
  }

  set cargo(String value) {
    this._prefs.setString('cargo', value);
  }

  String get imagen {
    return this._prefs.getString('imagen') ?? '';
  }

  set imagen(String value) {
    this._prefs.setString('imagen', value);
  }

  String get ultimaPagina {
    return _prefs.getString('ultimaPagina') ?? 'login';
  }

  set ultimaPagina(String value) {
    _prefs.setString('ultimaPagina', value);
  }

  String get imagenCredencial {
    return _prefs.getString('imagenCredencial') ?? '';
  }

  set imagenCredencial(String value) {
    _prefs.setString('imagenCredencial', value);
  }

  String get usuario {
    return _prefs.getString('usuario') ?? '';
  }

  set usuario(String value) {
    _prefs.setString('usuario', value);
  }

  String get password {
    return _prefs.getString('password') ?? '';
  }

  set password(String value) {
    _prefs.setString('password', value);
  }

  String get sessionid {
    return _prefs.getString('sessionid') ?? '';
  }

  set sessionid(String value) {
    _prefs.setString('sessionid', value);
  }

  int get controlacceso {
    return _prefs.getInt('controlacceso') ?? 0;
  }

  set controlacceso(int value) {
    _prefs.setInt('controlacceso', value);
  }
}
