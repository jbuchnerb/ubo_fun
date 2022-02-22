import 'package:flutter/material.dart';

//import 'menu.widget.dart';

class QrWidget extends StatefulWidget {
  final Widget child;

  QrWidget({required this.child});

  @override
  _QrWidgetState createState() => _QrWidgetState();
}

class _QrWidgetState extends State<QrWidget> {

  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      setState(() {});
    });
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
      //drawer: MenuWidget(),
      body: Container(child: this.widget.child),
    );
  }
}