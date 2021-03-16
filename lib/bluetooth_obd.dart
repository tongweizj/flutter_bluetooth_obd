import 'dart:async';

import 'package:flutter/services.dart';

class BluetoothObd {
  static const MethodChannel _channel = const MethodChannel('bluetooth_obd');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  // static int calculate1(int a, int b) {
  //   return a + b;
  // }

  static Future<int> calculate(int a, int b) async {
    var result = await _channel.invokeMethod('calculate', {'a': a, 'b': b});
    return int.parse(result);
  }

  // 启动 OBD 连接
  static Future<String> get startOBD async {
    final String startOBDMesg = await _channel.invokeMethod('startOBD');
    return startOBDMesg;
  }

  // 获得 OBD 数据
  static Future<String> get tripRecord async {
    final String tripRecords = await _channel.invokeMethod('getTripRecord');
    return tripRecords;
  }
}
