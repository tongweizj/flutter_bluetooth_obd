import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bluetooth_obd/bluetooth_obd.dart';
import 'package:flutter/services.dart';

/// Mix-in [DiagnosticableTreeMixin] to have access to [debugFillProperties] for the devtool
// ignore: prefer_mixin
class ObdReader with ChangeNotifier, DiagnosticableTreeMixin {
  String _tripRecords = '';
  String _obdSpeed = '';
  String _obdEngineCoolantTemp = '';
  String _obdEngineLoad = '';
  String _obdEngineRpm = '';
  String _obdModuleVoltage = '';
  String _obdDistanceMILOn = '';
  Map _obdData = {
    '0': ['Speed', '0'],
    '1': ['CoolantTemperature', '0'],
    '2': ['RPM', '0'],
    '3': ['EngineLoad', '0'],
    '4': ['ModuleVoltage', '0'],
    '5': ['DistanceMILOn', '0']
  };

  String get tripRecords => _tripRecords;
  String get obdSpeed => _obdSpeed;
  String get obdEngineCoolantTemp => _obdEngineCoolantTemp;
  String get obdEngineLoad => _obdEngineLoad;
  String get obdEngineRpm => _obdEngineRpm;
  String get obdModuleVoltage => _obdModuleVoltage;
  String get obdDistanceMILOn => _obdDistanceMILOn;
  Map get obdData => _obdData;

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
    // try {
    //   _tripRecords = await BluetoothObd.getSpeed;
    //   _obdData['0'][1] = _tripRecords;
    // } on PlatformException {
    //   _tripRecords = 'Failed to get tripRecords.';
    //   _obdData['0'][1] = 'Failed to get airIntakeTemperature.';
    // }

    // obd speed
    try {
      _obdSpeed = await BluetoothObd.getSpeed;
      _obdData['0'][1] = _obdSpeed;
    } on PlatformException {
      _obdSpeed = 'Failed to get speed.';
      _obdData['0'][1] = 'Failed to get speed.';
    }
    // obd EngineCoolantTemp
    try {
      _obdEngineCoolantTemp = await BluetoothObd.getAirIntakeTemperature;
      _obdData['1'][1] = _obdEngineCoolantTemp;
    } on PlatformException {
      _obdSpeed = 'Failed to get Engine Coolant Temp.';
      _obdData['1'][1] = 'Failed to get Engine Coolant Temp.';
    }
    // 获得 OBD RPM 数据
    try {
      _obdEngineRpm = await BluetoothObd.getRPM;
      _obdData['2'][1] = _obdEngineRpm;
    } on PlatformException {
      _obdEngineRpm = 'Failed to get Engine Rpm.';
      _obdData['2'][1] = 'Failed to get Engine Rpm.';
    }
    // obd getEngineLoad
    try {
      _obdEngineLoad = await BluetoothObd.getEngineLoad;
      _obdData['3'][1] = _obdEngineLoad;
    } on PlatformException {
      _obdEngineLoad = 'Failed to get Engine Load.';
      _obdData['3'][1] = 'Failed to get Engine Load.';
    }
    // obd getModuleVoltage
    try {
      _obdModuleVoltage = await BluetoothObd.getModuleVoltage;
      _obdData['4'][1] = _obdModuleVoltage;
    } on PlatformException {
      _obdModuleVoltage = 'Failed to get Module Voltage.';
      _obdData['4'][1] = 'Failed to get Module Voltage.';
    }
    // obd getDistanceMILOn
    try {
      _obdDistanceMILOn = await BluetoothObd.getDistanceMILOn;
      _obdData['5'][1] = _obdDistanceMILOn;
    } on PlatformException {
      _obdDistanceMILOn = 'Failed to get Distance MILOn.';
      _obdData['5'][1] = 'Failed to get Distance MILOn.';
    }
    notifyListeners();
  }
}
