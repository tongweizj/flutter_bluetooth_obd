import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_obd/bluetooth_obd.dart';
import 'package:flutter/services.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
// ignore: prefer_mixin
class Counter with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;
  String _platformVersion = '';
  String _tripRecords = '';
  int _calculateResult = 0;
  int get count => _count;
  String get platformVersion => _platformVersion;
  String get tripRecords => _tripRecords;
  int get calculateResult => _calculateResult;

  Future<void> startOBD() async {
    String obdMesg;
    try {
      obdMesg = await BluetoothObd.startOBD;
    } on PlatformException {
      obdMesg = 'Failed to start obdMesg.';
    }

    print(obdMesg);

    notifyListeners();
  }

  Future<void> increment() async {
    _count++;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      _platformVersion = await BluetoothObd.platformVersion;
    } on PlatformException {
      _platformVersion = 'Failed to get platform version.';
    }
    try {
      _tripRecords = await BluetoothObd.tripRecord;
    } on PlatformException {
      _tripRecords = 'Failed to get tripRecords.';
    }

    // init 的时候，计算一下 10 + 10 的结果
    _calculateResult = await BluetoothObd.calculate(10, 10);

    notifyListeners();
  }

  /// Makes `Counter` readable inside the devtools by listing all of its properties
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('count', count));
  }
}