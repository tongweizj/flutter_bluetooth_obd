import 'package:flutter/material.dart';

Widget buildCard(String title, String obdData) {
  return Card(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
          alignment: Alignment.topLeft,
          height: 30.0,
          child: Text(title),
        ),
        Center(
          child: Container(
              margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
              height: 100.0,
              child: Center(
                child: Text(obdData),
              )),
        ),
      ],
    ),
  );
}

// Center(
//                   child: Card(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: <Widget>[
//                         Container(
//                           margin: const EdgeInsets.fromLTRB(15, 15, 0, 0),
//                           alignment: Alignment.topLeft,
//                           height: 30.0,
//                           child: Text('Item $index'),
//                         ),
//                         Center(
//                           child: Container(
//                               margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
//                               height: 100.0,
//                               child: Center(
//                                 child: Text('1000'),
//                               )),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
