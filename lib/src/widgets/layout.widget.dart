import 'package:flutter/material.dart';

import 'menu.widget.dart';

class LayoutWidget extends StatefulWidget {
  final Widget child;

  LayoutWidget({@required this.child});

  @override
  _LayoutWidgetState createState() => _LayoutWidgetState();
}

class _LayoutWidgetState extends State<LayoutWidget> {

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
      drawer: MenuWidget(),
      body: Container(child: this.widget.child),
    );
  }
}
