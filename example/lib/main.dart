import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:bluetooth_obd/bluetooth_obd.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  // 定义一个 int 型变量，用于保存计算结果
  int _calculateResult;
  String _tripRecords = 'Unknown';
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String tripRecords;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await BluetoothObd.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    try {
      tripRecords = await BluetoothObd.tripRecord;
    } on PlatformException {
      tripRecords = 'Failed to get tripRecords.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // init 的时候，计算一下 10 + 10 的结果
    _calculateResult = await BluetoothObd.calculate(10, 10);
    setState(() {
      _platformVersion = platformVersion;
      _tripRecords = tripRecords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Running on: $_platformVersion\n'),
                // 输出该结果
                Text('Calculate Result: $_calculateResult\n'),
                Text('tripRecords Result: $_tripRecords\n'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
