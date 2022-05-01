import 'package:flutter/material.dart';

bool isNumeric(String s) {
  if (s.isEmpty) return false;

  final n = num.tryParse(s);

  return (n == null) ? false : true;
}

void mostrarAlerta(BuildContext context, String? mensaje) {
  mensaje = mensaje ?? '';
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(mensaje!),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });

  /*Widget verticalText(String text)
{
  return Wrap(
    direction: Axis.vertical,
    children: [
        RotatedBox(quarterTurns: 1,child: Text(text,
          style: TextStyle(color: Colors.white,fontSize: 20),)),

    ],
  );
}*/
}
