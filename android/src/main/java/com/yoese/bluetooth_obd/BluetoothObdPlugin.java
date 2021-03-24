package com.yoese.bluetooth_obd;

import androidx.annotation.NonNull;
import android.content.Context;
import android.content.IntentFilter;
import android.content.BroadcastReceiver;
import android.content.Intent;
import android.content.ContextWrapper;
import android.graphics.Color;
import android.os.Bundle;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
/** Obd Reader Lib*/
import com.sohrab.obd.reader.application.Preferences;
import com.sohrab.obd.reader.obdCommand.ObdCommand;
import com.sohrab.obd.reader.obdCommand.ObdConfiguration;
import com.sohrab.obd.reader.obdCommand.SpeedCommand;
import com.sohrab.obd.reader.obdCommand.control.DistanceMILOnCommand;
import com.sohrab.obd.reader.obdCommand.control.ModuleVoltageCommand;
import com.sohrab.obd.reader.obdCommand.engine.LoadCommand;
import com.sohrab.obd.reader.obdCommand.engine.MassAirFlowCommand;
import com.sohrab.obd.reader.obdCommand.engine.RPMCommand;
import com.sohrab.obd.reader.obdCommand.temperature.AirIntakeTemperatureCommand;
import com.sohrab.obd.reader.obdCommand.temperature.EngineCoolantTemperatureCommand;
import com.sohrab.obd.reader.service.ObdReaderService;
import com.sohrab.obd.reader.trip.TripRecord;
import java.util.ArrayList;

import static com.sohrab.obd.reader.constants.DefineObdReader.ACTION_CONNECTION_STATUS_MSG;
import static com.sohrab.obd.reader.constants.DefineObdReader.ACTION_READ_OBD_REAL_TIME_DATA;

/** BluetoothObdPlugin */
public class BluetoothObdPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;

  String obdSpeed;
  String obdEngineCoolantTemp;
  String obdEngineLoad;
  String obdEngineRpm;
  String obdModuleVoltage;
  String obdDistanceMILOn;
  BroadcastReceiver mObdReaderReceiver;
  Intent obdIntent;
  String obdAction ;
  String obdMesg;
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "bluetooth_obd");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }


  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if (call.method.equals("calculate")) {
      int a  = call.argument("a");
      int b  = call.argument("b");
      int r = a + b;
      result.success("" + r);
    } else if (call.method.equals("startOBD")) {
     
      ArrayList<ObdCommand> obdCommands = new ArrayList<>();
      obdCommands.add(new SpeedCommand()); //speed
      obdCommands.add(new RPMCommand()); //rpm
      obdCommands.add(new LoadCommand()); //engine load
      obdCommands.add(new EngineCoolantTemperatureCommand()); //coolant temp
      obdCommands.add(new ModuleVoltageCommand()); //fuel pressure
      obdCommands.add(new AirIntakeTemperatureCommand()); //oil temp
      obdCommands.add(new MassAirFlowCommand()); //MAF
      obdCommands.add(new DistanceMILOnCommand()); //MIL distance
      ObdConfiguration.setmObdCommands(context, obdCommands);

      //Register receiver with some action related to OBD connection status and read PID values
      IntentFilter intentFilter = new IntentFilter();
      intentFilter.addAction(ACTION_READ_OBD_REAL_TIME_DATA);
      intentFilter.addAction(ACTION_CONNECTION_STATUS_MSG);

      //bluetooth receiver method
      mObdReaderReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
          obdIntent = intent;
          obdAction = intent.getAction();
          System.out.println("Hello, World 2");
          if (obdAction.equals(ACTION_CONNECTION_STATUS_MSG)) {
              String connectionStatusMsg = intent.getStringExtra(ObdReaderService.INTENT_EXTRA_DATA);
              //OBD connected  do what want after OBD connection
              System.out.println("Hello, World 3");
              System.out.println(context.getString(R.string.connected_ok));
              if (connectionStatusMsg.equals(context.getString(R.string.connected_ok))) {
                  //OBD connected  do what want after OBD connection
                  System.out.println("蓝牙连接成功");
                  obdMesg =  "蓝牙连接成功";
                  
              } else {
                  //OBD connected  do what want after OBD connection
                  System.out.println("蓝牙连接不成功");
                  obdMesg =  "蓝牙连接不成功";
              }
          } else if (obdAction.equals(ACTION_READ_OBD_REAL_TIME_DATA)) {
            //   TripRecord tripRecord = TripRecord.getTripRecode(context);
              
            //   // rpm.setText(tripRecord.getEngineRpm()); //display rpm
            //   if (tripRecord.getSpeed() != null) {
            //     obdSpeed = String.valueOf(tripRecord.getSpeed()); //display speed
            // }else{
            //   obdSpeed = "no Speed signal";
            // }
            // if (tripRecord.getmEngineCoolantTemp() != null) {
            //   obdEngineCoolantTemp = String.valueOf(tripRecord.getmEngineCoolantTemp()); ;//display coolant temp
            // }else{
            //   obdEngineCoolantTemp = "no EngineCoolantTemp signal";
            // }
          }
        }
      };
      System.out.println("Hello, World 1");
      context.registerReceiver(mObdReaderReceiver, intentFilter);
      //start service that keep running in background for connecting and execute command until you stop
      context.startService(new Intent(context, ObdReaderService.class));
      
      
      result.success("蓝牙连接成功");
    } else if (call.method.equals("getTripRecord")) {
      System.out.println("开始getTripRecord");
      if (obdAction.equals(ACTION_CONNECTION_STATUS_MSG)) {
        String connectionStatusMsg = obdIntent.getStringExtra(ObdReaderService.INTENT_EXTRA_DATA);
        //OBD connected  do what want after OBD connection
        System.out.println("Hello, World 3");
        System.out.println(context.getString(R.string.connected_ok));
        if (connectionStatusMsg.equals(context.getString(R.string.connected_ok))) {
            //OBD connected  do what want after OBD connection
            System.out.println("蓝牙连接成功");
        } else {
            //OBD connected  do what want after OBD connection
            System.out.println("蓝牙连接不成功");
        }
      } else if (obdAction.equals(ACTION_READ_OBD_REAL_TIME_DATA)) {
        TripRecord tripRecord = TripRecord.getTripRecode(context);
        System.out.println("tripRecord");
        System.out.println(tripRecord);
        
        if (tripRecord.getmEngineCoolantTemp() != null) {
          obdEngineCoolantTemp = String.valueOf(tripRecord.getmEngineCoolantTemp()); ;//display coolant temp
        }else{
          obdEngineCoolantTemp = "no EngineCoolantTemp signal";
        }
      }
      result.success("" + obdEngineCoolantTemp);
    } else if (call.method.equals("getSpeed")) {
      System.out.println("开始 getSpeed");
      if (obdAction.equals(ACTION_READ_OBD_REAL_TIME_DATA)) {
          TripRecord tripRecord = TripRecord.getTripRecode(context);
          if (tripRecord.getSpeed() != null) {
            obdSpeed = String.valueOf(tripRecord.getSpeed()); //display speed
        }else{
          obdSpeed = "no Speed signal";
        }
      }
      result.success("" + obdSpeed);

    }else if (call.method.equals("getRPM")) {
      System.out.println("开始 getRPM");
      if (obdAction.equals(ACTION_READ_OBD_REAL_TIME_DATA)) {
          TripRecord tripRecord = TripRecord.getTripRecode(context);
          if (tripRecord.getEngineRpm() != null) {
            obdEngineRpm = String.valueOf(tripRecord.getEngineRpm()); //display speed
        }else{
          obdEngineRpm = "no Speed signal";
        }
      }
      result.success("" + obdEngineRpm);

    }else if (call.method.equals("getAirIntakeTemperature")) {
      System.out.println("开始 getAirIntakeTemperature");
      if (obdAction.equals(ACTION_READ_OBD_REAL_TIME_DATA)) {
          TripRecord tripRecord = TripRecord.getTripRecode(context);
          if (tripRecord.getmEngineCoolantTemp() != null) {
            obdEngineCoolantTemp = String.valueOf(tripRecord.getmEngineCoolantTemp()); ;//display coolant temp
          }else{
            obdEngineCoolantTemp = "no EngineCoolantTemp signal";
          }
      }
      result.success("" + obdEngineCoolantTemp);

    }else if (call.method.equals("getEngineLoad")) {
      System.out.println("开始 getEngineLoad");
      if (obdAction.equals(ACTION_READ_OBD_REAL_TIME_DATA)) {
          TripRecord tripRecord = TripRecord.getTripRecode(context);
          if (tripRecord.getmEngineLoad() != null) {
            obdEngineLoad = String.valueOf(tripRecord.getmEngineLoad()); //display speed
        }else{
          obdEngineLoad = "no Speed signal";
        }
      }
      result.success("" + obdEngineLoad);

    }else if (call.method.equals("getModuleVoltage")) {
      System.out.println("开始 getModuleVoltage");
      if (obdAction.equals(ACTION_READ_OBD_REAL_TIME_DATA)) {
          TripRecord tripRecord = TripRecord.getTripRecode(context);
          if (tripRecord.getmControlModuleVoltage() != null) {
            obdModuleVoltage = String.valueOf(tripRecord.getmControlModuleVoltage()); //display speed
        }else{
          obdModuleVoltage = "no Module Voltage signal";
        }
      }
      result.success("" + obdModuleVoltage);

    }else if (call.method.equals("getDistanceMILOn")) {
      System.out.println("开始 getDistanceMILOn");
      if (obdAction.equals(ACTION_READ_OBD_REAL_TIME_DATA)) {
          TripRecord tripRecord = TripRecord.getTripRecode(context);
          if (tripRecord.getmDistanceTraveledMilOn() != null) {
            obdDistanceMILOn = String.valueOf(tripRecord.getmDistanceTraveledMilOn()); //display speed
        }else{
          obdDistanceMILOn = "no Distance MILOn signal";
        }
      }
      result.success("" + obdDistanceMILOn);
    }else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
