import 'dart:convert';
//import 'dart:html';

import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ubo_fun/src/preferencias_usuario/preferencias_usuario.dart';
import 'package:ubo_fun/src/noticias_usuario/noticias_usuario.dart';
import 'package:ubo_fun/src/providers/noticias_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatefulWidget {
  static final String routeName = 'news';

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  List _listaNoticias;

  final _prefs = new PreferenciasUsuario();
 
  final _news = new NoticiasUsuario();

  final _newsprovider = new NoticiasProvider();

  //ScrollController _controller = ScrollController();

  @override
  void initState() {
    //print(_news.noticias);
     _listaNoticias = json.decode(_news.noticias) as List;
    // print(_listaNoticias);
    updateNews();
    super.initState();
  }

  @override
   Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Color.fromRGBO(8, 54, 130, 1.0),
          actions: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.transparent),
              margin: EdgeInsets.all(5),
              child: Image.asset("assets/img/logo_ubo_white.png"),
            )
          ],
          // iconTheme: new IconThemeData(color: Colors.black),
        ),
        body: Container(
      margin: EdgeInsets.all(10),
      child:
          RefreshIndicator(onRefresh: updateNews, child: generateNews(context)),));
  }

 /* Widget build(BuildContext context) {
    //_prefs.ultimaPagina = NewsPage.routeName;
    return LayoutWidget(
        child: Container(
      margin: EdgeInsets.all(10),
      child:
          RefreshIndicator(onRefresh: updateNews, child: generateNews(context)),
    ));
  }*/
  

  ListView generateNews(context) {
     // print(_listaNoticias);
    return ListView.builder(
      
        itemCount: _listaNoticias.length,
        itemBuilder: (BuildContext context, int index) {

          return generateCard(context,
              idnoticia: _listaNoticias[index]['id'],
              title: _listaNoticias[index]['titulo'],
              text: _listaNoticias[index]['cuerpo'],
              image: null,
              reaccion: _listaNoticias[index]['liked'],
              reacciones: _listaNoticias[index]['likes'],
              read: _listaNoticias[index]['read'],
              enlace: _listaNoticias[index]['link'],
              index: index
              ); 
                      });
  } 

  generateCard(context, { @required idnoticia, @required title, @required text, @required image,@required reaccion,@required reacciones,@required read,@required enlace,@required index}) {
    bool breaccion=false;
    bool enabled=true;
    /*Image imagenews;
    if (image == null) {
      //getImagenNews(idnoticia);
      image = Image.network('http://192.168.1.123/api/noticia/$idnoticia/imagen').image;
      //image = await _newsprovider.getImagenNoticia(idnoticia);
     // image = Image.asset("assets/img/logo_ubo.png").image;
    }else{
      image = Image.asset("assets/img/logo_ubo.png").image;
    }*/

    if (reaccion==1) {
       breaccion=true;
    }

    //Size size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ClipRRect(
              // width: size.width*.9,
              // height: 10, });
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: FadeInImage(
                  placeholder: Image.asset("assets/img/logo_ubo.png").image,
                  image: Image.network('http://funcionarios.ubo.cl/api/noticia/$idnoticia/imagen').image,
                  )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center
            ),
          ),
          ExpandChild(

          indicatorBuilder: (context, onTap, expanded) { 
            

           return AbsorbPointer(
                  absorbing: !enabled,
                  child: InkWell(
                    onTap: (){
                      onTap();
                      if (!expanded){
                          onExpandTap(idnoticia);
                          //print(idnoticia);
                          }
                      setState(() {
                        enabled = false;
                      });
                    },
                    child: Icon(
                        expanded? Icons.expand_less_outlined
                        : Icons.expand_more_outlined
                      ),
                  ),
                );
          },

              child: Column(
                //onExpandTap(idnoticia),
                children: <Widget>[
                  Text(text,
                  textAlign: TextAlign.justify),
              getEnlace(enlace),

                ],
              ),
            ),
        ],
      ),
    );
  }

  Future updateNews() async {
    var result = await _newsprovider.getNoticias();
    _listaNoticias.clear();
    //print(_news.noticias);
    _listaNoticias = json.decode(_news.noticias) as List;
    setState(() {});
    return generateNews(context);
  }

  Future<bool> onLikeButtonTapped(breaccion,idnoticia,index) async{
    /*var result =*/ await _newsprovider.getReaccionar(idnoticia);
    if (breaccion==true){
      _listaNoticias[index]['liked']=0;
      _listaNoticias[index]['likes']-=1;
    } else {
      _listaNoticias[index]['liked']=1;
      _listaNoticias[index]['likes']+=1;
    }    
    setState(() {});
    return !breaccion;
  }

   Future<void> onExpandTap(idnoticia) async{
    await _newsprovider.getLectura(idnoticia);

  }

  getEnlace(String enlace) {
    if (enlace==null){
      return Text('');
    }
    else {
      return ListTile(
                       title: Text('$enlace'),
                       onTap: () async {
                           if (await canLaunch(enlace)) {
                              await launch(enlace, forceSafariVC: false,);
                            } else {
                              throw 'No fue posible abrir el enlace $enlace';
                            }
                              },
                            );
    }
              
  }
}

