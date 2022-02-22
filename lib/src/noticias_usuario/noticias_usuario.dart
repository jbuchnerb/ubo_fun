import 'package:shared_preferences/shared_preferences.dart';

class NoticiasUsuario {
  static final NoticiasUsuario _instancia = NoticiasUsuario._internal();

  factory NoticiasUsuario() {
    return _instancia;
  }

  NoticiasUsuario._internal();

  late SharedPreferences _news;

  initPrefs() async {
    _news = await SharedPreferences.getInstance();
  }

  clear() async {
    final retorno = await _news.clear();
    return retorno;
  }

  String get noticias {
    return _news.getString('noticias') ?? '[]';
  }

  set noticias(String value) {
    _news.setString('noticias', value);
  }

/*  get idnoticia {
    return this._news.getString('idnoticia') ?? '[]';
  }

  set idnoticia(String value) {
    this._news.setString('idnoticia', value);
  }

   get titulo {
    return this._news.getString('titulo') ?? '';
  }

  set titulo(String value) {
    this._news.setString('titulo', value);
  }

    get cuerpo {
    return this._news.getString('cuerpo') ?? '';
  }

  set cuerpo(String value) {
    this._news.setString('cuerpo', value);
  }

  get urlimagen {
    return this._news.getString('urlimagen') ?? '';
  }

  set urlimagen(String value) {
    this._news.setString('urlimagen', value);
  }

  get likes {
    return this._news.getInt('likes') ?? '';
  }

  set likes(int value) {
    this._news.setInt('likes', value);
  }

  get liked {
    return this._news.getInt('liked') ?? '';
  }

  set liked(int value) {
    this._news.setInt('liked', value);
  }

  get read {
    return this._news.getInt('read') ?? '';
  }

  set read(int value) {
    this._news.setInt('read', value);
  }*/
}
