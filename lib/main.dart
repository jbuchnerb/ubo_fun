import 'package:flutter/material.dart';
import 'package:ubo_fun/src/noticias_usuario/noticias_usuario.dart';
import 'package:ubo_fun/src/pages/credential2.page.dart';
import 'package:ubo_fun/src/pages/home.page.dart';
import 'package:ubo_fun/src/pages/news.page.dart';
import 'package:ubo_fun/src/pages/password.page.dart';
import 'package:ubo_fun/src/pages/patentes.page.dart';
import 'package:ubo_fun/src/pages/profile_image.page.dart';
import 'package:ubo_fun/src/pages/qrscan.page.dart';
import 'package:ubo_fun/src/pages/login.page.dart';
import 'package:ubo_fun/src/bloc/provider.dart';
import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferenciasUsuario();
  final news = NoticiasUsuario();
  await prefs.initPrefs();
  await news.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _prefs = PreferenciasUsuario();
  final String routeName = 'login';

  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: _prefs.ultimaPagina,
        // initialRoute: 'login',
        routes: getRoutes(),
        theme: getThemeData(),
      ),
    );
  }

  ThemeData getThemeData() {
    return ThemeData(
      primaryColor: Color(0xff043480),
      // primaryColor: Colors.white,
      canvasColor: Color(0xfff5f5f5),
      primaryIconTheme: IconThemeData(color: Colors.white),
      textTheme: TextTheme(
        headline5: TextStyle(),
        headline6: TextStyle(),
        subtitle1: TextStyle(),
        subtitle2: TextStyle(),
      ).apply(
        bodyColor: Color(0xff043480),
      ),
    );
  }

  Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      LoginPage.routeName: (BuildContext context) => LoginPage(),
      HomePage.routeName: (BuildContext context) => HomePage(),
      NewsPage.routeName: (BuildContext context) => NewsPage(),
      Credential2Page.routeName: (BuildContext context) => Credential2Page(),
      QrScanPage.routeName: (BuildContext context) => QrScanPage(),
      ProfileImage.routeName: (BuildContext context) => ProfileImage(),
      PatentesPage.routeName: (BuildContext context) => PatentesPage(),
      PasswordPage.routeName: (BuildContext context) => PasswordPage(),
    };
  }
}
