import 'dart:async';

import 'package:flutter/services.dart';

class BluetoothObd {
  static const MethodChannel _channel = const MethodChannel('bluetooth_obd');

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

  // 获得 OBD-车速 数据
  static Future<String> get getSpeed async {
    final String tripRecords = await _channel.invokeMethod('getSpeed');
    return tripRecords;
  }

  // 获得 OBD RPM 数据
  static Future<String> get getRPM async {
    final String data = await _channel.invokeMethod('getRPM');
    return data;
  }

  // 获得 OBD 数据
  static Future<String> get getAirIntakeTemperature async {
    final String data = await _channel.invokeMethod('getAirIntakeTemperature');
    return data;
  }

  // 获得 OBD-车速 数据
  static Future<String> get getEngineLoad async {
    final String data = await _channel.invokeMethod('getEngineLoad');
    return data;
  }

  // 获得 OBD RPM 数据
  static Future<String> get getModuleVoltage async {
    final String data = await _channel.invokeMethod('getModuleVoltage');
    return data;
  }

  // 获得 OBD 数据
  static Future<String> get getDistanceMILOn async {
    final String data = await _channel.invokeMethod('getDistanceMILOn');
    return data;
  }
}
